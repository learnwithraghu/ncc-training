# Guide 1: Basic AWS CLI Commands

## What you’ll learn
- Verify AWS CLI is installed
- Configure credentials
- List common AWS resources
- Read basic account and region info

## 1) Check the CLI
```bash
aws --version
```

## 2) Configure AWS CLI
```bash
aws configure
```

You will be prompted for:
- AWS Access Key ID
- AWS Secret Access Key
- Default region name
- Default output format

## 3) Confirm identity
```bash
aws sts get-caller-identity
```

## 4) List S3 buckets
```bash
aws s3 ls
```

## 5) List EC2 instances
```bash
aws ec2 describe-instances
```

## 6) List your configured region and output
```bash
aws configure list
```

## 7) See help for any service
```bash
aws ec2 help
aws s3 help
```

## Checkpoint
- What region is your CLI configured to use?
- Can you see your AWS account ID from `sts get-caller-identity`?
- What happens when you run `aws s3 ls`?
