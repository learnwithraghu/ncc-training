# Step 04: Push the Docker Image to Amazon ECR

## Goal
Understand Amazon ECR, create a repository, and push your locally built image from your laptop.

## Time
Approximately **25 minutes**.

## What You Brought Forward

```text
04-ecr-push/
├── guide.md
├── app.py
├── requirements.txt
├── Dockerfile
├── .dockerignore
└── docker-compose.yml
```

Bring secrets forward (shared template is `../.env_example`):

```bash
cp ../03-local-image-test/.env ./.env
```

Confirm the local image still exists:

```bash
docker images | grep document-search
```

If the image is missing, rebuild here first:

```bash
docker build --platform linux/amd64 -t document-search:latest .
```

---

## Tutor Talk: What Is Amazon ECR?

**Amazon Elastic Container Registry (ECR)** is a private Docker registry hosted by AWS.

Think of the flow as:

```text
Your laptop                  AWS
-----------                  ----
docker build  -->  docker push  -->  ECR repository stores the image
                                         |
                                         v
                                   ECS pulls that image to run a task
```

Key ideas for students:

- A **repository** holds related image tags (for example `document-search:latest`)
- You must **authenticate Docker to ECR** before push/pull with IAM credentials
- ECS does not use the image sitting only on your laptop; it needs the image in ECR (or another registry AWS can reach)

---

## Step 1: Load Credentials for the AWS CLI

```bash
cd 11-Capstone-Document-Search/04-ecr-push
export $(grep -v '^#' .env | xargs)
```

Verify identity:

```bash
aws sts get-caller-identity
```

Fill the account ID used in image URIs:

```bash
export ECR_REGISTRY_ID=$(aws sts get-caller-identity --query Account --output text)
echo "$ECR_REGISTRY_ID"
```

You can also store that value back into `.env` as `ECR_REGISTRY_ID=...` for next time.

---

## Step 2: Create the ECR Repository

### Option A — AWS CLI (local)

```bash
aws ecr create-repository \
  --repository-name "$ECR_REPOSITORY_NAME" \
  --region "$AWS_REGION" \
  --image-scanning-configuration scanOnPush=true
```

If you see `RepositoryAlreadyExistsException`, that is fine — continue.

Verify:

```bash
aws ecr describe-repositories \
  --repository-names "$ECR_REPOSITORY_NAME" \
  --region "$AWS_REGION"
```

### Option B — AWS Console

1. Open **Amazon ECR**
2. **Create repository**
3. Name: `document-search` (or the value in `ECR_REPOSITORY_NAME`)
4. Enable **Scan on push**
5. Create

---

## Step 3: Authenticate Docker to ECR

```bash
aws ecr get-login-password --region "$AWS_REGION" | \
  docker login --username AWS --password-stdin \
  "$ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
```

Expected output: `Login Succeeded`

Tutor note: this login token expires. If a later push fails with auth errors, run this command again.

---

## Step 4: Tag the Local Image for ECR

ECR needs a fully qualified name:

```text
<account-id>.dkr.ecr.<region>.amazonaws.com/<repo>:<tag>
```

```bash
docker tag document-search:latest \
  "$ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:latest"
```

## Step 5: Push

```bash
docker push \
  "$ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:latest"
```

Watch layer uploads finish. The first push is slowest.

## Step 6: Verify

**CLI:**

```bash
aws ecr describe-images \
  --repository-name "$ECR_REPOSITORY_NAME" \
  --region "$AWS_REGION"
```

**Console:** ECR → `document-search` → Images → tag `latest`

Write down your image URI. You will paste it into the ECS task definition next:

```text
$ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:latest
```

---

## Quick Full Sequence

```bash
export $(grep -v '^#' .env | xargs)
export ECR_REGISTRY_ID=$(aws sts get-caller-identity --query Account --output text)

aws ecr get-login-password --region "$AWS_REGION" | \
  docker login --username AWS --password-stdin \
  "$ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

docker build --platform linux/amd64 -t document-search:latest .
docker tag document-search:latest \
  "$ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:latest"
docker push \
  "$ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:latest"
```

---

## Checkpoint

1. What problem does ECR solve between your laptop and ECS?
2. Why do you tag with the account ID and region in the name?
3. Are AWS access keys used here for the **CLI on your laptop**, for the **image contents**, or both in this lab?

## Next Step

Go to **[05-ecs-deploy](../05-ecs-deploy/)** — deploy the ECR image with the **AWS Console** and open the task public IP.
