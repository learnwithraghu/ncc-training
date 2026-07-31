# Step 04: Push the Docker Image to Amazon ECR

## Goal
Create an ECR repository and push your locally built License Renewal image from your laptop.

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

## Step 1: Load CLI Credentials

```bash
cd 11-Capstone-Document-Search/04-ecr-push
export $(grep -v '^#' .env | xargs)
aws sts get-caller-identity
export ECR_REGISTRY_ID=$(aws sts get-caller-identity --query Account --output text)
```

## Step 2: Create Repository

```bash
aws ecr create-repository \
  --repository-name "$ECR_REPOSITORY_NAME" \
  --region "$AWS_REGION" \
  --image-scanning-configuration scanOnPush=true
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
3. Why must the image already include working `LLM_*` settings?

## Next Step

Go to **[05-ecs-deploy](../05-ecs-deploy/)**.
