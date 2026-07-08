# Lesson 5: Pushing Docker Images to AWS ECR

This lesson covers integrating Jenkins with AWS ECR (Elastic Container Registry). You'll learn how to create ECR repositories, configure AWS credentials, and push Docker images from Jenkins pipelines.

## Learning Objectives

- Create ECR repository in AWS
- Configure AWS credentials for Jenkins
- Log in to ECR from Jenkins
- Tag and push Docker images to ECR
- Verify images in ECR
- Understand IAM roles and permissions

## Prerequisites

- Jenkins installed and running (Lesson 1)
- Docker build working in Jenkins (Lesson 4)
- AWS account with ECR access
- AWS CLI installed (on Jenkins server or locally)
- Basic understanding of AWS IAM

## Step 1: Create ECR Repository

### Option A: Using AWS CLI (Recommended)

```bash
# Create ECR repository
aws ecr create-repository \
    --repository-name ncc-training-app \
    --region us-east-1 \
    --image-scanning-configuration scanOnPush=true

# Get repository URI
aws ecr describe-repositories \
    --repository-names ncc-training-app \
    --region us-east-1 \
    --query 'repositories[0].repositoryUri' \
    --output text
```

**Output example**: `123456789012.dkr.ecr.us-east-1.amazonaws.com/ncc-training-app`

### Option B: Using Provided Script

```bash
# On your local machine
cd 04-Jenkins/scripts
chmod +x ecr-setup.sh
./ecr-setup.sh --name ncc-training-app --region us-east-1
```

### Option C: Using AWS Console

1. **Go to**: AWS Console → ECR → Repositories → Create repository
2. **Repository name**: `ncc-training-app`
3. **Visibility**: Private
4. **Scan on push**: Enabled
5. **Click**: Create repository

**Note the repository URI** - you'll need it later!

## Step 2: Configure AWS Credentials

You have two options: IAM Role (recommended for EC2) or AWS Credentials.

### Option A: IAM Role (Recommended for EC2)

This is the most secure method when Jenkins runs on EC2.

#### Create IAM Role

```bash
# Create trust policy
cat > trust-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# Create IAM role
aws iam create-role \
    --role-name JenkinsEC2Role \
    --assume-role-policy-document file://trust-policy.json

# Attach ECR policy
aws iam attach-role-policy \
    --role-name JenkinsEC2Role \
    --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess

# Create instance profile
aws iam create-instance-profile --instance-profile-name JenkinsEC2Profile

# Add role to instance profile
aws iam add-role-to-instance-profile \
    --instance-profile-name JenkinsEC2Profile \
    --role-name JenkinsEC2Role
```

#### Attach Role to EC2 Instance

```bash
# Get your instance ID
INSTANCE_ID=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=Jenkins-Server" \
    --query 'Reservations[0].Instances[0].InstanceId' \
    --output text)

# Attach instance profile
aws ec2 associate-iam-instance-profile \
    --instance-id $INSTANCE_ID \
    --iam-instance-profile Name=JenkinsEC2Profile
```

#### Verify IAM Role

```bash
# SSH into Jenkins server
ssh -i your-key-pair.pem ubuntu@<JENKINS_IP>

# Check if role is attached
aws sts get-caller-identity
```

### Option B: AWS Credentials in Jenkins

If you can't use IAM roles, store credentials in Jenkins:

1. **In Jenkins**: Manage Jenkins → Credentials → System → Global credentials

2. **Add Credentials**:
   - **Kind**: `AWS Credentials`
   - **Access Key ID**: Your AWS access key
   - **Secret Access Key**: Your AWS secret key
   - **ID**: `aws-credentials`
   - **Description**: `AWS Credentials for ECR`

3. **Click**: **OK**

## Step 3: Install AWS CLI on Jenkins Server

```bash
# SSH into Jenkins server
ssh -i your-key-pair.pem ubuntu@<JENKINS_IP>

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify installation
aws --version

# If using credentials (not IAM role), configure:
aws configure
# Enter: Access Key ID, Secret Access Key, Region, Output format
```

## Step 4: Create ECR Login Pipeline

### Basic ECR Login and Push

```groovy
pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '123456789012'  // Replace with your account ID
        ECR_REPOSITORY = 'ncc-training-app'
        APP_NAME = 'ncc-training-app'
        DOCKER_IMAGE = "${APP_NAME}:${BUILD_NUMBER}"
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        ECR_IMAGE = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${BUILD_NUMBER}"
        ECR_IMAGE_LATEST = "${ECR_REGISTRY}/${ECR_REPOSITORY}:latest"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                dir('03-Docker/application') {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        
        stage('Login to ECR') {
            steps {
                script {
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    """
                }
            }
        }
        
        stage('Tag and Push') {
            steps {
                script {
                    sh """
                        docker tag ${DOCKER_IMAGE} ${ECR_IMAGE}
                        docker tag ${DOCKER_IMAGE} ${ECR_IMAGE_LATEST}
                        docker push ${ECR_IMAGE}
                        docker push ${ECR_IMAGE_LATEST}
                    """
                }
            }
        }
    }
}
```

## Step 5: Get AWS Account ID Dynamically

Instead of hardcoding account ID, get it dynamically:

```groovy
stage('Get AWS Account ID') {
    steps {
        script {
            def accountId = sh(
                script: 'aws sts get-caller-identity --query Account --output text',
                returnStdout: true
            ).trim()
            env.AWS_ACCOUNT_ID = accountId
            env.ECR_REGISTRY = "${accountId}.dkr.ecr.${AWS_REGION}.amazonaws.com"
            echo "Using AWS Account ID: ${accountId}"
        }
    }
}
```

## Step 6: Complete Pipeline with Error Handling

```groovy
pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY = 'ncc-training-app'
        APP_NAME = 'ncc-training-app'
        DOCKER_IMAGE = "${APP_NAME}:${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Get AWS Account ID') {
            steps {
                script {
                    try {
                        def accountId = sh(
                            script: 'aws sts get-caller-identity --query Account --output text',
                            returnStdout: true
                        ).trim()
                        env.AWS_ACCOUNT_ID = accountId
                        env.ECR_REGISTRY = "${accountId}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                        echo "AWS Account ID: ${accountId}"
                    } catch (Exception e) {
                        echo "Warning: Could not get AWS Account ID"
                        echo "Error: ${e.getMessage()}"
                        env.SKIP_ECR = 'true'
                    }
                }
            }
        }
        
        stage('Build') {
            steps {
                dir('03-Docker/application') {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        
        stage('ECR Login') {
            when {
                expression { return env.SKIP_ECR != 'true' }
            }
            steps {
                script {
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin ${env.ECR_REGISTRY}
                    """
                }
            }
        }
        
        stage('Tag and Push') {
            when {
                expression { return env.SKIP_ECR != 'true' }
            }
            steps {
                script {
                    def ecrImage = "${env.ECR_REGISTRY}/${ECR_REPOSITORY}:${BUILD_NUMBER}"
                    def ecrImageLatest = "${env.ECR_REGISTRY}/${ECR_REPOSITORY}:latest"
                    
                    sh """
                        docker tag ${DOCKER_IMAGE} ${ecrImage}
                        docker tag ${DOCKER_IMAGE} ${ecrImageLatest}
                        docker push ${ecrImage}
                        docker push ${ecrImageLatest}
                    """
                    
                    env.ECR_IMAGE_URI = ecrImage
                    echo "Successfully pushed: ${ecrImage}"
                }
            }
        }
        
        stage('Verify Push') {
            when {
                expression { return env.SKIP_ECR != 'true' }
            }
            steps {
                script {
                    def images = sh(
                        script: "aws ecr list-images --repository-name ${ECR_REPOSITORY} --region ${AWS_REGION} --query 'imageIds[*].imageTag' --output text",
                        returnStdout: true
                    ).trim()
                    echo "Images in ECR: ${images}"
                }
            }
        }
    }
    
    post {
        always {
            script {
                // Cleanup local images
                sh "docker rmi ${DOCKER_IMAGE} || true"
                if (env.ECR_IMAGE_URI) {
                    sh "docker rmi ${env.ECR_IMAGE_URI} || true"
                }
            }
        }
        success {
            if (env.ECR_IMAGE_URI) {
                echo "✅ Image pushed to ECR: ${env.ECR_IMAGE_URI}"
            }
        }
    }
}
```

## Step 7: Using AWS Credentials from Jenkins

If using stored credentials instead of IAM role:

```groovy
stage('ECR Login') {
    steps {
        withCredentials([aws(credentialsId: 'aws-credentials', variable: 'AWS_CREDENTIALS')]) {
            sh """
                aws ecr get-login-password --region ${AWS_REGION} | \
                docker login --username AWS --password-stdin ${ECR_REGISTRY}
            """
        }
    }
}
```

## Step 8: Verify Images in ECR

### Using AWS CLI

```bash
# List images in repository
aws ecr list-images \
    --repository-name ncc-training-app \
    --region us-east-1

# Describe specific image
aws ecr describe-images \
    --repository-name ncc-training-app \
    --image-ids imageTag=1 \
    --region us-east-1
```

### Using AWS Console

1. **Go to**: AWS Console → ECR → Repositories → ncc-training-app
2. **View images**: See all pushed images with tags
3. **Click image**: View details, scan results, etc.

## Step 9: Practice Exercise

Create a pipeline that:

1. Gets AWS account ID dynamically
2. Builds Docker image
3. Logs into ECR
4. Tags image with build number and latest
5. Pushes both tags to ECR
6. Lists all images in ECR repository
7. Handles errors gracefully

**Reference**: See the complete pipeline in Step 6 above.

## Troubleshooting

### ECR Login Fails

**Problem**: `Error: Cannot perform an interactive login`

**Solutions**:
- Verify AWS credentials are configured
- Check IAM permissions for ECR
- Verify region is correct
- Test login manually: `aws ecr get-login-password --region us-east-1`

### Access Denied

**Problem**: `AccessDeniedException` when pushing

**Solutions**:
- Check IAM role has `AmazonEC2ContainerRegistryFullAccess` policy
- Verify repository name is correct
- Check region matches
- Verify account ID is correct

### Repository Not Found

**Problem**: `RepositoryNotFoundException`

**Solutions**:
- Verify repository exists: `aws ecr describe-repositories`
- Check repository name spelling
- Verify region is correct
- Create repository if it doesn't exist

### Push Fails

**Problem**: Docker push fails

**Solutions**:
- Check image is tagged correctly
- Verify ECR login succeeded
- Check network connectivity
- View detailed error in Jenkins console

## Key Takeaways

✅ **ECR Repository**: Create repository before pushing  
✅ **AWS Credentials**: Use IAM roles (recommended) or stored credentials  
✅ **ECR Login**: Use `aws ecr get-login-password`  
✅ **Image Tagging**: Tag with version and latest  
✅ **Error Handling**: Handle AWS errors gracefully  
✅ **Verification**: Verify images after push  

## Next Steps

Excellent! You can now push Docker images to AWS ECR.

**In the next lesson**, you'll learn advanced Groovy pipeline patterns and best practices.

**Before moving on**, make sure:
- ✅ ECR repository created
- ✅ AWS credentials configured
- ✅ Can push images to ECR
- ✅ Can verify images in ECR

---

**Ready for advanced topics?** Move to [06-groovy-advanced.md](./06-groovy-advanced.md) for advanced pipeline patterns!

