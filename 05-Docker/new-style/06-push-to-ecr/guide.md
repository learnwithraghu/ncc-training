# 06: Push to ECR

**Time:** ~20 minutes

## Goal
From the same EC2 instance, authenticate to Amazon ECR using the **instance IAM role**, tag your built image with the repository URI, and push it. This is the last topic in the module.

Do not create access keys. Do not use `~/.aws/credentials`. The EC2 role is how this lab talks to AWS.

## Commands to Teach

```bash
aws sts get-caller-identity
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
docker tag ncc-training-app:1.0 <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<repo>:1.0
docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<repo>:1.0
```

- `aws sts get-caller-identity` must show an `assumed-role` ARN from the EC2 instance profile.
- `get-login-password | docker login` gives Docker a short-lived ECR token from that role. You do not paste AWS keys into Docker.
- `docker tag` rewrites the local name to the ECR URI. ECR will not accept `ncc-training-app:1.0` until it is tagged this way.
- `docker push` uploads layers from this EC2 host to ECR. The image is not pushed from your laptop.

## Guided Steps

1. Build the image on EC2 if it is not already present:

```bash
cd ~/ncc-training/05-Docker/application
docker build -t ncc-training-app:1.0 .
```

2. Confirm the instance role can call AWS. Region for this lab is `us-east-1`:

```bash
aws sts get-caller-identity
```

If this fails, or the ARN is not `assumed-role`, stop and tell the instructor. The EC2 instance must already have an IAM role that can push to ECR.

3. Copy the image URI from AWS Console (**ECR → Repositories → your repo**) and set it as a variable. Include the tag:

```bash
ECR_IMAGE_URI="<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<repo>:1.0"
ECR_REGISTRY=$(echo "$ECR_IMAGE_URI" | cut -d/ -f1)
ECR_REPOSITORY_NAME=$(echo "$ECR_IMAGE_URI" | cut -d/ -f2 | cut -d: -f1)
```

Confirm the repository exists:

```bash
aws ecr describe-repositories \
  --repository-names "$ECR_REPOSITORY_NAME" \
  --region us-east-1
```

The instructor creates the ECR repository in the Console before class. You do not create it in this topic.

4. Login, tag, and push from EC2:

```bash
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin "$ECR_REGISTRY"

docker tag ncc-training-app:1.0 "$ECR_IMAGE_URI"
docker push "$ECR_IMAGE_URI"
```

5. Verify the image landed in ECR:

```bash
aws ecr describe-images \
  --repository-name "$ECR_REPOSITORY_NAME" \
  --region us-east-1
```

Save the image URI. This module ends here.

## Task

Build `ncc-training-app:1.0` on EC2. Use the ECR repository URI your instructor gives you. Login, tag the local image with that URI, push it, and confirm the image appears in `aws ecr describe-images`. If login or push fails, confirm `aws sts get-caller-identity` shows `assumed-role` and tell the instructor.

## Checkpoint
Why does this lab use the EC2 instance IAM role instead of access keys, and what does `docker tag` change before `docker push`?
