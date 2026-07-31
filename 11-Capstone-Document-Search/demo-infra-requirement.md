# Demo Infra Requirement

## Infra Needed

- Docker (Docker Compose optional for Step 03)
- AWS CLI with credentials that can use ECR
- AWS Console access for ECR, ECS, VPC/security groups, and CloudWatch Logs
- A VPC with at least one public subnet (default VPC is fine)
- Security group allowing inbound TCP `5000` from your IP

## Quick Validation

```bash
docker --version
docker compose version
aws --version
aws sts get-caller-identity
aws ecr describe-repositories --region "${AWS_REGION:-us-east-1}"
aws ecs list-clusters --region "${AWS_REGION:-us-east-1}"
```

Per-step env check (example for Step 01):

```bash
cd 01-application-overview
test -f .env_example && echo "env template present"
cp -n .env_example .env
```

## Console Checks

- Amazon ECR: can create repository `document-search`
- Amazon ECS: can create a Fargate cluster and service
- EC2 → Security Groups: inbound TCP `5000`
- CloudWatch Logs: task logs visible after deploy
