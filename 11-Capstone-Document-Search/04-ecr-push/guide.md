# Step 04: Push the Docker Image to Amazon ECR

## Goal
Use already configured AWS credentials in `~/.aws/credentials`, hardcode region as `us-east-1`, and push your locally built License Renewal image using the ECR URI copied from AWS Console.

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

The Streamlit app uses `LLM_*` values that were baked into the image.

In this setup, AWS CLI authentication comes from `~/.aws/credentials` (already configured).

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

## Step 2: Copy ECR URI from AWS Console

In AWS Console, open **ECR → Repositories → document-search** and copy the image URI.

Paste it in terminal as an environment variable:

```bash
ECR_IMAGE_URI="<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/document-search:latest"
```

Verify your active AWS identity:

```bash
aws sts get-caller-identity
```

Optional check (to confirm credential source):

```bash
ls -la ~/.aws/credentials ~/.aws/config
aws configure list
```

Confirm your ECR repository exists (created in Console):

```bash
ECR_REPOSITORY_NAME=$(echo "$ECR_IMAGE_URI" | cut -d/ -f2 | cut -d: -f1)
aws ecr describe-repositories \
  --repository-names "$ECR_REPOSITORY_NAME" \
  --region us-east-1
```

## Step 3: Login, Tag, Push

```bash
ECR_REGISTRY=$(echo "$ECR_IMAGE_URI" | cut -d/ -f1)

aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin "$ECR_REGISTRY"

docker tag document-search:latest "$ECR_IMAGE_URI"

docker push "$ECR_IMAGE_URI"
```

## Step 4: Verify

```bash
aws ecr describe-images \
  --repository-name "$ECR_REPOSITORY_NAME" \
  --region us-east-1
```

Save your image URI for ECS.

---

## Checkpoint

1. What does ECR provide between your laptop and ECS?
2. Are AWS keys used here for CLI, for the Streamlit LLM call, or both?
3. Why is copying the exact ECR URI from Console safer than manually typing it?
4. Why must the image already include working `LLM_*` settings?

## Next Step

Go to **[05-ecs-deploy](../05-ecs-deploy/)**.
