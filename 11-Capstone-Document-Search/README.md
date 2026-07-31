# Day 5, Part 3: Document Search Capstone

This module is the final project of the NCC DevOps Bootcamp. Work **one folder at a time**. Each folder includes the code you need for that step plus a tutor-style guide. Later folders carry forward everything from earlier ones.

## Learning Path

```text
01 Application overview
        ↓
02 Dockerize (write Dockerfile; bake .env into the image)
        ↓
03 Build & test the image locally
        ↓
04 Push the image to Amazon ECR (from your laptop)
        ↓
05 Deploy with ECS Console (Fargate + task public IP)
        ↓
06 Final demo
```

## What You Will Learn

- Prepare application code and a safe `.env_example` / `.env` workflow
- Write a Dockerfile and bake secrets into the image for this lab (no Secrets Manager)
- Build and test the image on your laptop
- Create an ECR repository and push from local Docker
- Deploy with the AWS Console and open `http://<task-public-ip>:5000`

## Time Estimate

Approximately **2 hours**.

## Prerequisites

- Completion of [06-Docker](../06-Docker/README.md) and ECR concepts from [08-GitHub-Actions](../08-GitHub-Actions/README.md)
- Docker (and optionally Docker Compose)
- AWS CLI plus an AWS account for ECR and ECS Console access

## Step Folders

| Step | Folder | What you do | Duration |
|------|--------|-------------|----------|
| 1 | [01-application-overview](01-application-overview/guide.md) | Meet the app and create `.env` | 15 min |
| 2 | [02-dockerize](02-dockerize/guide.md) | Write the Dockerfile; bake secrets | 20 min |
| 3 | [03-local-image-test](03-local-image-test/guide.md) | Build and test locally | 20 min |
| 4 | [04-ecr-push](04-ecr-push/guide.md) | Create ECR repo and push | 25 min |
| 5 | [05-ecs-deploy](05-ecs-deploy/guide.md) | Deploy from the AWS Console | 30 min |
| 6 | [06-final-demo](06-final-demo/guide.md) | Present the end-to-end path | 20 min |

## How to Use These Folders

1. Open the step folder for the lesson you are on.
2. Read `guide.md` first.
3. Use the code in **that same folder** (do not jump ahead).
4. When you finish, copy your filled `.env` into the next folder if the guide says so.
5. Each later folder already contains the prior application files so a late joiner can still catch up.

## Capstone Rules

- Build locally → push to ECR from your laptop → deploy ECS from the **Console**
- Access via the **ECS task public IP** (no Application Load Balancer in this lab)
- Bake `.env` into the image for this classroom path; **do not** use AWS Secrets Manager here
- Never commit a real `.env`

## Key Artifact

An image in Amazon ECR running as an ECS Fargate task, reachable at `http://<task-public-ip>:5000`.

## Infra Checklist

See [demo-infra-requirement.md](demo-infra-requirement.md).
