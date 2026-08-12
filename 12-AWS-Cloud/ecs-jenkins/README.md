# ECS Jenkins

Run Jenkins on Amazon ECS Fargate from the AWS Console. Guide 1 uses the public Docker Hub image in the task definition. Guide 2 switches the same task family to an Amazon ECR pull-through cache URI.

This module teaches **cluster, security group, task definition, and service**. It does **not** replace [07-Jenkins](../../07-Jenkins/README.md). Full CI labs (bind mounts, pipelines, Docker-in-Jenkins) stay on EC2.

## What you build

Jenkins UI at:

```text
http://<TASK_PUBLIC_IP>:8080
```

The public IP is temporary. It can change when the task is replaced.

## Guides

| Guide | File | Time |
|-------|------|------|
| 1 | [guide-01-jenkins-ecs-public-image.md](./guide-01-jenkins-ecs-public-image.md) | ~30 min |
| 2 | [guide-02-jenkins-ecs-ecr-pull-through.md](./guide-02-jenkins-ecs-ecr-pull-through.md) | ~25 min |

Infra checklist: [demo-infra-requirement.md](./demo-infra-requirement.md)

## Image used in the task definition

- Guide 1: `jenkins/jenkins:lts-jdk17` (Docker Hub)
- Guide 2: `<ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/docker-hub/jenkins/jenkins:lts-jdk17` (ECR pull-through)

## How this differs from 07-Jenkins

| Feature | EC2 + Docker (`07-Jenkins`) | ECS Fargate (this lab) |
|---------|----------------------------|------------------------|
| Persistent `jenkins_home` | Named volume | Ephemeral — lost on task replace |
| Bind mount `~/jenkins-code` | Yes | No |
| Docker socket / build images | Topic 12 | Not supported on Fargate |
| Access | EC2 public IP :8080 | Task public IP :8080 |

Advanced: Docker-in-Jenkins needs a host Docker socket. That pattern belongs on **ECS on EC2**, not Fargate. Do not use it in this lab.

## Prerequisites

- AWS Console access for ECS, ECR, EC2 security groups, IAM, CloudWatch Logs, and Secrets Manager
- A VPC with at least one public subnet (the default VPC is fine)
- Region such as `us-east-1`
- Docker Hub username and access token for Guide 2 only
