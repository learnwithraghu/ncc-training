# Guide 01: Build Docker Image and Push to AWS ECR

This guide explains how to build the License Renewal Document Processor Docker image locally and push it to AWS Elastic Container Registry (ECR).

## Prerequisites

- Docker installed and running locally
- AWS CLI installed and configured
- AWS account with appropriate permissions
- ECR repository created (or we'll create it in this guide)

## IAM Permissions Required

To push Docker images to ECR, your IAM user/role needs the following permissions:

### Recommended: Use Admin Access
For development/testing, the simplest approach is to attach the `AdministratorAccess` policy to your IAM user/role. This provides all necessary permissions.

### Required ECR Permissions (If Not Using Admin)
- `ecr:GetAuthorizationToken` - Required for Docker login to ECR
- `ecr:BatchCheckLayerAvailability` - Check if image layers exist
- `ecr:GetDownloadUrlForLayer` - Download image layers
- `ecr:BatchGetImage` - Get image manifests
- `ecr:PutImage` - Push images to repository
- `ecr:InitiateLayerUpload` - Start uploading image layers
- `ecr:UploadLayerPart` - Upload image layer parts
- `ecr:CompleteLayerUpload` - Complete layer upload
- `ecr:CreateRepository` - Create ECR repository (if creating via CLI)
- `ecr:DescribeRepositories` - List and describe repositories

**Quick Setup**: Attach the managed policy `AmazonEC2ContainerRegistryFullAccess` to your IAM user/role for all ECR operations.

See the main [README.md](README.md) for complete IAM permissions including Bedrock and S3.

## Step 1: Update Environment Variables

First, ensure your `.env` file contains all necessary variables. Add ECR-specific variables:

```bash
# Edit your .env file
nano .env
```

Add or update these variables:

```env
# AWS Credentials
AWS_ACCESS_KEY_ID=your_aws_access_key_id
AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
AWS_REGION=us-east-1

# Bedrock Configuration
BEDROCK_MODEL_ID=anthropic.claude-3-sonnet-20240229-v1:0

# S3 Configuration
S3_BUCKET_NAME=your-s3-bucket-name

# ECR Configuration
ECR_REPOSITORY_NAME=license-renewal-processor
ECR_REGISTRY_ID=your-aws-account-id
```

**Note**: Replace `your-aws-account-id` with your actual AWS account ID. You can find it in the AWS Console or by running:
```bash
aws sts get-caller-identity --query Account --output text
```

## Step 2: Create ECR Repository

If you haven't created an ECR repository yet, create it using AWS CLI:

```bash
# Set your region
export AWS_REGION=us-east-1

**Alternative**: Create via AWS Console:
1. Go to Amazon ECR in AWS Console
2. Click "Create repository"
3. Repository name: `license-renewal-processor`
4. Enable "Scan on push"
5. Click "Create repository"

## Step 3: Authenticate Docker to ECR

Authenticate your Docker client to your ECR registry:

```bash
# Load AWS credentials from .env (if using)
export $(cat .env | grep -v '^#' | xargs)

# Authenticate Docker to ECR
aws ecr get-login-password --region $AWS_REGION | \
    docker login --username AWS --password-stdin \
    $ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com
```

**Expected output**: `Login Succeeded`

## Step 4: Build Docker Image

Navigate to the project directory and build the Docker image:

```bash
cd /path/to/document-search-website

# Build the image for linux/amd64 platform (required for ECS Fargate)
docker build --platform linux/amd64 -t license-renewal-processor:latest .
```

**Important**: Always use `--platform linux/amd64` when building for ECS Fargate, even if you're building on an ARM-based machine (like Apple Silicon Macs). ECS Fargate uses x86_64 architecture.

**Note**: The build process will:
- Copy your `.env` file into the image
- Install all Python dependencies
- Set up the application

**Build time**: Approximately 2-5 minutes depending on your internet connection.

## Step 5: Tag Image for ECR

Tag your local image with the ECR repository URI:

```bash
# Get your AWS account ID (if not already in .env)
export ECR_REGISTRY_ID=$(aws sts get-caller-identity --query Account --output text)

# Tag the image
docker tag license-renewal-processor:latest \
    $ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com/license-renewal-processor:latest
```

**Alternative**: Tag with a specific version:

```bash
docker tag license-renewal-processor:latest \
    $ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com/license-renewal-processor:v1.0.0
```

## Step 6: Push Image to ECR

Push the tagged image to your ECR repository:

```bash
# Push the image
docker push $ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com/license-renewal-processor:latest
```

**Expected output**: You'll see upload progress and confirmation when complete.

## Step 7: Verify Image in ECR

Verify the image was pushed successfully:

### Using AWS CLI:
```bash
aws ecr describe-images \
    --repository-name license-renewal-processor \
    --region $AWS_REGION
```

### Using AWS Console:
1. Go to Amazon ECR in AWS Console
2. Click on `license-renewal-processor` repository
3. You should see your image with tag `latest`
4. Check the image details (size, push date, scan status)

## Step 8: Test the Image Locally (Optional)

Before deploying, you can test the image locally:

```bash
# Run the container
docker run  \
    -p 8501:8501 \
    --name license-renewal-test \
    license-renewal-processor:latest

# Check logs
docker logs license-renewal-test

# Access the application
# Open browser: http://localhost:8501

# Stop and remove container
docker stop license-renewal-test
docker rm license-renewal-test
```

## Troubleshooting

### Issue: Authentication Failed
```bash
# Re-authenticate
aws ecr get-login-password --region $AWS_REGION | \
    docker login --username AWS --password-stdin \
    $ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com
```

### Issue: Permission Denied
- Ensure your AWS credentials have `ecr:GetAuthorizationToken` and `ecr:BatchCheckLayerAvailability` permissions
- Check IAM user/role has `AmazonEC2ContainerRegistryFullAccess` or equivalent permissions

### Issue: Repository Not Found
- Verify repository name matches exactly
- Check you're using the correct AWS region
- Ensure repository exists: `aws ecr describe-repositories --region $AWS_REGION`

### Issue: Build Fails
- Check `.env` file exists in the project root
- Verify all required environment variables are set
- Check Docker daemon is running: `docker ps`

### Issue: exec format error in ECS
- **Cause**: Architecture mismatch - image built for wrong platform
- **Solution**: Always build with `--platform linux/amd64` flag:
  ```bash
  docker build --platform linux/amd64 -t license-renewal-processor:latest .
  ```
- ECS Fargate requires linux/amd64 (x86_64) architecture, even if building on ARM-based machines

## Quick Reference Commands

```bash
# Full workflow (assuming .env is configured)
export $(cat .env | grep -v '^#' | xargs)
export ECR_REGISTRY_ID=$(aws sts get-caller-identity --query Account --output text)

# Authenticate
aws ecr get-login-password --region $AWS_REGION | \
    docker login --username AWS --password-stdin \
    $ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build (with platform specification for ECS compatibility)
docker build --platform linux/amd64 -t license-renewal-processor:latest .

# Tag
docker tag license-renewal-processor:latest \
    $ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com/license-renewal-processor:latest

# Push
docker push $ECR_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com/license-renewal-processor:latest
```

## Next Steps

After successfully pushing the image to ECR, proceed to **GUIDE-02-DEPLOY-TO-ECS.md** to deploy the application on Amazon ECS.

## Security Notes

⚠️ **Important Security Considerations**:

1. **Never commit `.env` file**: It contains sensitive credentials
2. **Rotate credentials regularly**: Update AWS access keys periodically
3. **Use IAM roles**: For production, prefer IAM roles over access keys
4. **Enable ECR image scanning**: Already enabled in Step 2
5. **Review ECR repository policies**: Ensure proper access controls

## Additional Resources

- [AWS ECR Documentation](https://docs.aws.amazon.com/ecr/)
- [Docker Documentation](https://docs.docker.com/)
- [AWS CLI ECR Commands](https://docs.aws.amazon.com/cli/latest/reference/ecr/)
