# Day 5, Part 3: Document Search Capstone

This module is the final project of the NCC DevOps Bootcamp. Work **one folder at a time**. Each folder includes the License Renewal Document Processor code for that step plus a tutor-style guide.

The app is a **Streamlit** UI: upload a PDF, call your **LLM HTTP endpoint**, view structured data, and download Excel. There is **no Bedrock** and **no S3** in this lab.

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

- Configure `LLM_API_KEY`, `LLM_API_ENDPOINT`, and `LLM_MODEL` (plus AWS/ECR for CLI)
- Dockerize a Streamlit document processor and bake secrets for class
- Build and test on port **8501**
- Push to Amazon ECR from your laptop
- Deploy with the AWS Console and open `http://<task-public-ip>:8501`

## Time Estimate

Approximately **2 hours**.

## Prerequisites

- Completion of [06-Docker](../06-Docker/README.md) and ECR concepts from [08-GitHub-Actions](../08-GitHub-Actions/README.md)
- Docker (and optionally Docker Compose)
- AWS CLI plus an AWS account for ECR and ECS Console access
- An OpenAI-compatible LLM HTTP endpoint and API key

## Step Folders

| Step | Folder | What you do | Duration |
|------|--------|-------------|----------|
| 1 | [01-application-overview](01-application-overview/guide.md) | Meet the app and create `.env` | 20 min |
| 2 | [02-dockerize](02-dockerize/guide.md) | Write the Dockerfile; bake secrets | 20 min |
| 3 | [03-local-image-test](03-local-image-test/guide.md) | Build and test locally on 8501 | 20 min |
| 4 | [04-ecr-push](04-ecr-push/guide.md) | Use `~/.aws/credentials` and push to ECR | 25 min |
| 5 | [05-ecs-deploy](05-ecs-deploy/guide.md) | Deploy from the AWS Console | 30 min |
| 6 | [06-final-demo](06-final-demo/guide.md) | Present the end-to-end path | 20 min |

## How to Use These Folders

1. Open the step folder for the lesson you are on.
2. Read `guide.md` first.
3. Use the code in **that same folder**.
4. Copy your filled `.env` forward when the guide says so. Use the single module-root [`.env_example`](.env_example).
5. Later folders already contain prior application files so late joiners can catch up.

## Capstone Rules

- Build locally → push to ECR from your laptop → deploy ECS from the **Console**
- Access via the **ECS task public IP** on port **8501** (no ALB in this lab)
- Bake `.env` into the image for this classroom path; **do not** use Secrets Manager here
- Never commit a real `.env`
- No Bedrock and no S3 in the application path

## Key Artifact

An image in Amazon ECR running as an ECS Fargate task, reachable at `http://<task-public-ip>:8501`.

## Infra Checklist

See [demo-infra-requirement.md](demo-infra-requirement.md).
