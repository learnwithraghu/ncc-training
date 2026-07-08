# Day 4, Guide 8: Build and Push to ECR with GitHub Actions

## Goal
Build a GitHub Actions workflow that builds a Docker image and pushes it to Amazon ECR.

## Time
Approximately **60 minutes**.

## Prerequisites

- Completion of [guide_01_actions_basics.md](guide_01_actions_basics.md)
- AWS account with ECR access
- Docker image source in `ncc-labs` repository

---

## 1. Required AWS Credentials

You need these secrets in your GitHub repository:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `ECR_REPOSITORY`

Add them under **Settings → Secrets and variables → Actions**.

## 2. ECR Workflow

```yaml
name: Build and Push to ECR

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v2

      - name: Build, tag, and push image
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: ${{ secrets.ECR_REPOSITORY }}
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
```

---

## Hands-On: Add ECR Workflow to ncc-labs

### Step 1: Ensure your Dockerfile is in the repository root

Your `ncc-labs` repo should have a `Dockerfile` at the top level (or in a `flask-redis/` folder with the correct context).

### Step 2: Create the workflow

```bash
cd ~/ncc-labs
cat > .github/workflows/docker-build.yml << 'EOF'
name: Build and Push to ECR

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v2

      - name: Build and push Docker image
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: ${{ secrets.ECR_REPOSITORY }}
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG ./flask-redis
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
EOF
```

### Step 3: Add secrets and push

1. Add the AWS secrets in GitHub repository settings.
2. Commit and push:

```bash
git add .
git commit -m "Add ECR build workflow"
git push origin main
```

### Step 4: Verify

1. Go to **Actions** in your GitHub repo
2. Watch the workflow run
3. Check ECR for the new image

---

## Day 4 Completion Checklist

By the end of this guide, you should have:

- [ ] A Jenkins pipeline that builds/pushes to ECR
- [ ] A GitHub Actions workflow that builds/pushes to ECR
- [ ] Understanding of when to use Jenkins vs GitHub Actions

On **Day 5**, you will deploy the container image to Kubernetes using Helm.

---

## Check Your Understanding

1. Why do you need to log in to ECR before pushing?
2. What is the purpose of `github.sha` as an image tag?
3. How is GitHub Actions different from Jenkins?
4. What are the security risks of storing AWS keys in GitHub secrets?
