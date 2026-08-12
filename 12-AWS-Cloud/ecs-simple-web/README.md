# ECS Simple Web + Load Balancer

Run a public **nginx** website on Amazon ECS Fargate and front it with an **Application Load Balancer (ALB)** — all from the AWS Console.

This lab teaches **cluster, task definition, service, target group, and load balancer wiring**. It uses a small public Docker Hub image so learners focus on ECS, not application build steps.

## What you build

A stable URL like:

```text
http://<ALB_DNS_NAME>
```

The browser shows the default nginx welcome page. Traffic goes **Browser → ALB → Fargate task**. You do not use the task public IP in this lab.

## Guide

| Guide | File | Time |
|-------|------|------|
| 1 | [guide-01-ecs-nginx-with-alb.md](./guide-01-ecs-nginx-with-alb.md) | ~35 min |

Infra checklist: [demo-infra-requirement.md](./demo-infra-requirement.md)

## Image used in the task definition

- `nginx:latest` (official image on Docker Hub)

Why this image:

- One line in the task definition — no ECR setup required
- Pulls quickly on first task start
- Serves a real web page on port **80**
- Works cleanly with ALB HTTP health checks on `/`

## How this differs from ECS Jenkins

| Feature | ECS Jenkins (`ecs-jenkins/`) | This lab |
|---------|------------------------------|----------|
| Image | `jenkins/jenkins:lts-jdk17` | `nginx:latest` |
| Container port | 8080 | 80 |
| Access | Task public IP | ALB DNS name |
| Load balancer | None | Application Load Balancer |
| Best for | Jenkins UI on Fargate | ECS + ALB fundamentals |

## Prerequisites

- AWS Console access for ECS, EC2 security groups, IAM, and CloudWatch Logs
- A VPC with at least **two public subnets** (default VPC is fine)
- Region such as `us-east-1`
