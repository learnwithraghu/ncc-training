# Demo Infra Requirement

## Infra Needed

- AWS Console access for ECS, ECR, VPC/security groups, IAM, CloudWatch Logs, and Secrets Manager
- A VPC with at least one public subnet (default VPC is fine)
- Ability to create or use `ecsTaskExecutionRole`
- Security group allowing inbound TCP `8080` from your IP
- Outbound internet from the ECS task (Docker Hub pull, plugin downloads, ECR)
- Docker Hub username and access token for Guide 2 (ECR pull-through cache)

## Quick Validation

Optional. The guides themselves are Console-only.

```bash
aws sts get-caller-identity
aws ecs list-clusters --region "${AWS_REGION:-us-east-1}"
aws ecr describe-pull-through-cache-rules --region "${AWS_REGION:-us-east-1}"
```

## Console Checks

- Amazon ECS: can create a Fargate cluster, task definition, and service
- EC2 → Security Groups: inbound TCP `8080` from **My IP**
- IAM: `ecsTaskExecutionRole` exists, or the task definition wizard can create it
- CloudWatch Logs: task logs visible after deploy (`/ecs/jenkins`)
- Amazon ECR: can create a Docker Hub pull-through cache rule (Guide 2)
- Browser can open `http://<TASK_PUBLIC_IP>:8080`
