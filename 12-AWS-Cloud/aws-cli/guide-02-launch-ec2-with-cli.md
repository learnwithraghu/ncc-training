# Guide 2: Launch EC2 with AWS CLI

## Goal
Spin up a simple EC2 instance with default-style settings using the AWS CLI.

## 1) Choose a region
Make sure your CLI is pointing to the region where you want the instance.

```bash
aws configure get region
```

## 2) Find a recent Amazon Linux 2 AMI
Use SSM to get the latest Amazon Linux 2 AMI ID.

```bash
aws ssm get-parameters \
  --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
  --query 'Parameters[0].Value' \
  --output text
```

Save the AMI ID from the output.

## 3) Launch the instance
Replace `ami-xxxxxxxx` with the AMI from step 2.

```bash
aws ec2 run-instances \
  --image-id ami-xxxxxxxx \
  --instance-type t2.micro \
  --min-count 1 \
  --max-count 1
```

## 4) Check the instance
```bash
aws ec2 describe-instances
```

## 5) Get just the instance IDs
```bash
aws ec2 describe-instances \
  --query 'Reservations[].Instances[].InstanceId' \
  --output text
```

## Notes
- This is the simplest CLI-based launch flow.
- It uses default VPC/subnet behavior if your account supports it.
- You may still need a key pair or security group later for SSH access.

## Checkpoint
- What AMI ID did you use?
- Did the instance launch successfully?
- Can you find the instance ID in `describe-instances`?
