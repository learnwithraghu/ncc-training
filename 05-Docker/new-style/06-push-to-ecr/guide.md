# 06: Push to ECR

**Time:** ~20 minutes

## Goal
From the same EC2 instance, authenticate to Amazon ECR, tag your built image with the repository URI, and push it. This is the last topic in the module.

## Commands to Teach

```bash
aws sts get-caller-identity
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
docker tag ncc-training-app:1.0 <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<repo>:1.0
docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<repo>:1.0
```

- `aws sts get-caller-identity` proves the EC2 instance can call AWS (instance role or `~/.aws/credentials`).
- `get-login-password | docker login` gives Docker a short-lived ECR token. You do not paste long-lived AWS keys into Docker.
- `docker tag` rewrites the local name to the ECR URI. ECR will not accept `ncc-training-app:1.0` until it is tagged this way.
- `docker push` uploads layers from this EC2 host to ECR. The image is not pushed from your laptop.

## Guided Steps

1. Build the image on EC2 if it is not already present:

```bash
cd ~/ncc-training/05-Docker/application
docker build -t ncc-training-app:1.0 .
```

2. Confirm AWS identity. Region for this lab is `us-east-1`:

```bash
aws sts get-caller-identity
aws configure list
```

If this fails, stop and ask the instructor. You cannot push without credentials.

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

Build `ncc-training-app:1.0` on EC2. Use the ECR repository URI your instructor gives you. Login, tag the local image with that URI, push it, and confirm the image appears in `aws ecr describe-images`. If login or push fails, check identity and repository name before retrying.

## Checkpoint
Why do we push from EC2 to ECR instead of building on a laptop, and what does `docker tag` change before `docker push`?
