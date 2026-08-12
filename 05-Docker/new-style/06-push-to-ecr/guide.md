# 06: Push to ECR

**Time:** ~20 minutes

## Goal
Build the Aether Launch image in this folder, tag it with the ECR URI, and push from this EC2 instance using the instance IAM role.

Work only in this folder. It has its own `index.html` and `Dockerfile`.

Do not create access keys. Do not use `~/.aws/credentials`.

## Commands to Teach

```bash
aws sts get-caller-identity
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
docker tag aether-launch:1.0 <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<repo>:1.0
docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<repo>:1.0
```

- `aws sts get-caller-identity` must show an `assumed-role` ARN.
- `docker login` uses a short-lived ECR token from that role.
- `docker tag` applies the ECR naming convention from topic 05.
- `docker push` uploads layers from this EC2 host.

## Guided Steps

1. Build from this folder:

```bash
cd ~/ncc-training/05-Docker/new-style/06-push-to-ecr
docker build -t aether-launch:1.0 .
```

2. Confirm the instance role:

```bash
aws sts get-caller-identity
```

If the ARN is not `assumed-role`, stop and tell the instructor.

3. Set the ECR URI your instructor gives you (include the tag):

```bash
ECR_IMAGE_URI="<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<repo>:1.0"
ECR_REGISTRY=$(echo "$ECR_IMAGE_URI" | cut -d/ -f1)
ECR_REPOSITORY_NAME=$(echo "$ECR_IMAGE_URI" | cut -d/ -f2- | cut -d: -f1)
```

4. Login, tag, and push:

```bash
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin "$ECR_REGISTRY"

docker tag aether-launch:1.0 "$ECR_IMAGE_URI"
docker push "$ECR_IMAGE_URI"
```

5. Confirm ECR has the image:

```bash
aws ecr describe-images \
  --repository-name "$ECR_REPOSITORY_NAME" \
  --region us-east-1
```

Save the URI for [07-pull-and-run](../07-pull-and-run/guide.md).

## Task

From this folder, build `aether-launch:1.0`, tag it with the instructor ECR URI, push it, and confirm it with `aws ecr describe-images`.

## Checkpoint
Why must the local name `aether-launch:1.0` be tagged with the ECR URI before `docker push`?
