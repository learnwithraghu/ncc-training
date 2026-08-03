# Step 04: Push the Docker Image to Amazon ECR

## Goal
Configure AWS CLI in VS Code using access keys from `.env`, then push your locally built License Renewal image to an existing ECR repository.

## Time
Approximately **25 minutes**.

## What You Brought Forward

```text
04-ecr-push/
├── guide.md
├── requirements.txt
├── app/app.py
├── sample-documents/
├── Dockerfile
├── .dockerignore
└── docker-compose.yml
```

```bash
cp ../03-local-image-test/.env ./.env
docker images | grep document-search
```

If the image is missing:

```bash
docker build --platform linux/amd64 -t document-search:latest .
```

---

## Tutor Talk: ECR

ECR stores your image so ECS can pull it. Build and push stay on your laptop; deploy is Console later.

AWS access keys in `.env` are for **local AWS CLI** here. The Streamlit app uses `LLM_*` values that were baked into the image.

The ECR repository is created in the AWS Console before this step.

## Step 1: Set Up AWS CLI in VS Code Terminal

```bash
cd 11-Capstone-Document-Search/04-ecr-push
aws --version
```

If AWS CLI is missing (Ubuntu/Linux), install it:

```bash
sudo apt update && sudo apt install -y awscli
aws --version
```

## Step 2: Prepare `.env` and Configure AWS CLI

Make sure `.env` in this folder contains these values:

```env
AWS_ACCESS_KEY_ID=your_aws_access_key_id
AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
AWS_REGION=us-east-1
ECR_REPOSITORY_NAME=document-search
```

If needed, copy the shared template first:

```bash
cp -n ../.env_example .env
```

Load `.env`, configure the AWS CLI profile, and verify identity:

```bash
export $(grep -v '^#' .env | xargs)
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws configure set default.region "$AWS_REGION"
aws sts get-caller-identity
export ECR_REGISTRY_ID=$(aws sts get-caller-identity --query Account --output text)
```

Confirm your ECR repository exists (created in Console):

```bash
aws ecr describe-repositories \
  --repository-names "$ECR_REPOSITORY_NAME" \
  --region "$AWS_REGION"
```

## Step 3: Login, Tag, Push

```bash
aws ecr get-login-password --region "$AWS_REGION" | \
  docker login --username AWS --password-stdin \
  "$ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

docker tag document-search:latest \
  "$ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:latest"

docker push \
  "$ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:latest"
```

## Step 4: Verify

```bash
aws ecr describe-images \
  --repository-name "$ECR_REPOSITORY_NAME" \
  --region "$AWS_REGION"
```

Save your image URI for ECS.

---

## Checkpoint

1. What does ECR provide between your laptop and ECS?
2. Are AWS keys used here for CLI, for the Streamlit LLM call, or both?
3. Which values from `.env` were required to authenticate and push?
4. Why must the image already include working `LLM_*` settings?

## Next Step

Go to **[05-ecs-deploy](../05-ecs-deploy/)**.
