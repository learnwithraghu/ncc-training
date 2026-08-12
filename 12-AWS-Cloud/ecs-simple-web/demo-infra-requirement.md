# Demo Infra Requirement

## Infra Needed

- AWS Console access for ECS, EC2 (VPC, subnets, security groups), IAM, and CloudWatch Logs
- A VPC with at least **two public subnets** in different Availability Zones (default VPC is fine)
- Ability to create or use `ecsTaskExecutionRole`
- Outbound internet from ECS tasks (Docker Hub pull for `nginx:latest`)

## Why Two Public Subnets?

Application Load Balancers need subnets in at least two AZs. The default VPC usually includes them.

## Quick Validation

Optional. The guide is Console-only.

```bash
aws sts get-caller-identity
aws ecs list-clusters --region "${AWS_REGION:-us-east-1}"
aws ec2 describe-subnets --filters "Name=default-for-az,Values=true" --query "Subnets[].SubnetId" --output table --region "${AWS_REGION:-us-east-1}"
```

## Console Checks

- Amazon ECS: can create a Fargate cluster, task definition, and service
- EC2 → Security Groups: can create inbound rules for HTTP (port 80)
- IAM: `ecsTaskExecutionRole` exists, or the task definition wizard can create it
- CloudWatch Logs: task logs visible after deploy (`/ecs/nginx-demo`)
- Browser can open `http://<ALB_DNS_NAME>`
