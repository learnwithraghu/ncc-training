# Jenkins CI/CD Pipeline Challenge

## 🎯 Objective

Demonstrate your understanding of Jenkins CI/CD by setting up a complete pipeline that builds Docker images and pushes them to AWS ECR. This challenge integrates all concepts learned in the Jenkins module.

---

## 📋 Prerequisites & Lab Setup

Before starting this challenge, ensure you have completed:

- ✅ **Lesson 1**: Jenkins installed and running on EC2
- ✅ **Lesson 2**: Created at least one basic pipeline
- ✅ **Lesson 3**: Jenkins connected to GitHub
- ✅ **Lesson 4**: Docker installed on Jenkins server
- ✅ **Lesson 5**: AWS ECR repository created and accessible

### Lab Environment Requirements

You will need access to:

1. **Jenkins Server** (EC2 instance)
   - Jenkins installed and accessible via web UI
   - Docker installed and jenkins user in docker group
   - AWS CLI installed and configured
   - Required plugins installed (Git, GitHub, Docker Pipeline, AWS Steps)

2. **AWS Account**
   - ECR repository created (or permission to create one)
   - IAM role attached to EC2 instance OR AWS credentials configured
   - Region: `us-east-1` (or your preferred region)

3. **GitHub Repository**
   - Access to this `ncc-training` repository
   - Personal Access Token created
   - GitHub credentials configured in Jenkins

4. **Local Development Environment**
   - Git installed
   - Text editor (VS Code, vim, nano)
   - Terminal/command line access

### Verify Prerequisites

Run these checks before starting:

```bash
# 1. Verify Jenkins is accessible
curl -I http://<JENKINS_IP>:8080

# 2. Verify Docker on Jenkins server (SSH into server)
ssh -i your-key.pem ubuntu@<JENKINS_IP>
docker --version
sudo -u jenkins docker ps

# 3. Verify AWS CLI
aws --version
aws sts get-caller-identity

# 4. Verify ECR repository exists
aws ecr describe-repositories --repository-names ncc-training-app --region us-east-1

# 5. Verify GitHub access
git clone https://github.com/your-username/ncc-training.git
```

---

## 🚀 Challenge Tasks

### Task 1: Create ECR Repository (10 minutes)

**Goal**: Set up AWS ECR repository for storing Docker images.

**Instructions**:

1. **Create ECR repository** using AWS CLI:
   ```bash
   aws ecr create-repository \
       --repository-name ncc-training-app \
       --region us-east-1 \
       --image-scanning-configuration scanOnPush=true
   ```

2. **Get repository URI**:
   ```bash
   aws ecr describe-repositories \
       --repository-names ncc-training-app \
       --region us-east-1 \
       --query 'repositories[0].repositoryUri' \
       --output text
   ```

3. **Note the repository URI** - you'll need it in Task 3.

**Verification**:
- [ ] ECR repository created successfully
- [ ] Repository URI noted: `___________________________`
- [ ] Image scanning enabled

**Alternative**: Use the provided script:
```bash
cd 04-Jenkins/scripts
chmod +x ecr-setup.sh
./ecr-setup.sh --name ncc-training-app --region us-east-1
```

---

### Task 2: Configure Jenkins Job (15 minutes)

**Goal**: Create a Jenkins pipeline job connected to GitHub.

**Instructions**:

1. **In Jenkins Web UI**: Create a new Pipeline job
   - Name: `ncc-training-ci-cd`
   - Type: Pipeline

2. **Configure Pipeline**:
   - **Definition**: Pipeline script from SCM
   - **SCM**: Git
   - **Repository URL**: `https://github.com/your-username/ncc-training.git`
   - **Credentials**: Select your GitHub credentials
   - **Branch**: `*/main` (or `*/master`)
   - **Script Path**: `04-Jenkins/scripts/Jenkinsfile`

3. **Configure Build Triggers** (Optional but recommended):
   - Check: "GitHub hook trigger for GITScm polling"

4. **Save** the job configuration.

**Verification**:
- [ ] Job created successfully
- [ ] Job can checkout code from GitHub
- [ ] Job configuration saved

**Test**: Click "Build Now" and verify it can checkout the repository.

---

### Task 3: Create Custom Jenkinsfile (20 minutes)

**Goal**: Create a custom Jenkinsfile that builds Docker image and pushes to ECR.

**Instructions**:

1. **Create a new Jenkinsfile** in your repository:
   ```bash
   # On your local machine
   cd ncc-training
   mkdir -p 04-Jenkins/my-pipeline
   cd 04-Jenkins/my-pipeline
   ```

2. **Create Jenkinsfile** with the following requirements:
   - Must checkout code from GitHub
   - Must validate Dockerfile exists
   - Must build Docker image from `03-Docker/application`
   - Must tag image with: `ncc-app:${BUILD_NUMBER}` and `ncc-app:latest`
   - Must login to ECR
   - Must tag image for ECR: `${ECR_URI}:${BUILD_NUMBER}` and `${ECR_URI}:latest`
   - Must push both tags to ECR
   - Must verify push was successful
   - Must handle errors gracefully

3. **Use this template** (complete the missing parts):
   ```groovy
   pipeline {
       agent any
       
       environment {
           AWS_REGION = 'us-east-1'
           ECR_REPOSITORY = 'ncc-training-app'
           APP_NAME = 'ncc-app'
           // TODO: Add DOCKER_IMAGE variable
           // TODO: Add ECR_REGISTRY variable (get dynamically)
       }
       
       stages {
           stage('Checkout') {
               steps {
                   // TODO: Checkout code from SCM
               }
           }
           
           stage('Validate') {
               steps {
                   script {
                       // TODO: Check if Dockerfile exists
                       // TODO: Print validation message
                   }
               }
           }
           
           stage('Get AWS Account') {
               steps {
                   script {
                       // TODO: Get AWS account ID dynamically
                       // TODO: Set ECR_REGISTRY environment variable
                   }
               }
           }
           
           stage('Build') {
               steps {
                   // TODO: Build Docker image
                   // TODO: Tag as latest
               }
           }
           
           stage('ECR Login') {
               steps {
                   script {
                       // TODO: Login to ECR
                   }
               }
           }
           
           stage('Tag for ECR') {
               steps {
                   script {
                       // TODO: Tag image for ECR (build number and latest)
                   }
               }
           }
           
           stage('Push to ECR') {
               steps {
                   script {
                       // TODO: Push both tags to ECR
                   }
               }
           }
           
           stage('Verify') {
               steps {
                   script {
                       // TODO: List images in ECR repository
                   }
               }
           }
       }
       
       post {
           always {
               // TODO: Cleanup local images
           }
           success {
               // TODO: Print success message with ECR image URI
           }
           failure {
               // TODO: Print failure message
           }
       }
   }
   ```

4. **Commit and push** your Jenkinsfile:
   ```bash
   git add 04-Jenkins/my-pipeline/Jenkinsfile
   git commit -m "Add custom Jenkinsfile for challenge"
   git push
   ```

**Verification**:
- [ ] Jenkinsfile created with all required stages
- [ ] Code committed and pushed to GitHub
- [ ] All TODO items completed

**Reference**: See `04-Jenkins/scripts/Jenkinsfile` for a complete example.

---

### Task 4: Update Jenkins Job (10 minutes)

**Goal**: Configure Jenkins job to use your custom Jenkinsfile.

**Instructions**:

1. **Update Jenkins job configuration**:
   - Go to: `ncc-training-ci-cd` → Configure
   - **Script Path**: Change to `04-Jenkins/my-pipeline/Jenkinsfile`
   - **Save**

2. **Run the pipeline**:
   - Click "Build Now"
   - Watch the build progress
   - Check console output

3. **Fix any errors**:
   - Review console output for errors
   - Update Jenkinsfile if needed
   - Commit and push changes
   - Rebuild

**Verification**:
- [ ] Job uses custom Jenkinsfile
- [ ] Pipeline runs successfully
- [ ] All stages complete without errors
- [ ] Docker image built successfully
- [ ] Image pushed to ECR

---

### Task 5: Verify ECR Push (10 minutes)

**Goal**: Verify that Docker images are successfully pushed to ECR.

**Instructions**:

1. **List images in ECR**:
   ```bash
   aws ecr list-images \
       --repository-name ncc-training-app \
       --region us-east-1
   ```

2. **Describe specific image**:
   ```bash
   # Replace <BUILD_NUMBER> with actual build number
   aws ecr describe-images \
       --repository-name ncc-training-app \
       --image-ids imageTag=<BUILD_NUMBER> \
       --region us-east-1
   ```

3. **View in AWS Console**:
   - Go to: AWS Console → ECR → Repositories → ncc-training-app
   - Verify images are present
   - Check image tags (should see build numbers and "latest")

4. **Test pulling image** (optional):
   ```bash
   # Login to ECR
   aws ecr get-login-password --region us-east-1 | \
       docker login --username AWS --password-stdin \
       <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
   
   # Pull image
   docker pull <ECR_URI>:latest
   
   # Verify
   docker images | grep ncc-training-app
   ```

**Verification**:
- [ ] Images visible in ECR repository
- [ ] Multiple build numbers present
- [ ] "latest" tag exists
- [ ] Can pull image from ECR (optional)

---

### Task 6: Add Testing Stage (15 minutes)

**Goal**: Enhance pipeline with container testing.

**Instructions**:

1. **Update your Jenkinsfile** to add a testing stage after build:

   ```groovy
   stage('Test Container') {
       steps {
           script {
               def containerName = "${APP_NAME}-test-${BUILD_NUMBER}"
               try {
                   // TODO: Run container in detached mode
                   // TODO: Wait for container to start
                   // TODO: Test health endpoint
                   // TODO: Test main endpoint
                   // TODO: Print test results
               } finally {
                   // TODO: Stop and remove test container
               }
           }
       }
   }
   ```

2. **Place this stage** between "Build" and "ECR Login" stages.

3. **Test requirements**:
   - Container should start successfully
   - Health check (`/health`) should return 200
   - Main endpoint (`/`) should return JSON
   - Container should be cleaned up after tests

4. **Commit and push**:
   ```bash
   git add 04-Jenkins/my-pipeline/Jenkinsfile
   git commit -m "Add container testing stage"
   git push
   ```

5. **Run pipeline** and verify tests pass.

**Verification**:
- [ ] Testing stage added to pipeline
- [ ] Container starts successfully
- [ ] Health check passes
- [ ] Main endpoint returns valid JSON
- [ ] Container cleaned up after tests
- [ ] Pipeline continues to ECR push after tests

---

### Task 7: Add Parallel Stages (20 minutes)

**Goal**: Optimize pipeline with parallel execution.

**Instructions**:

1. **Update your Jenkinsfile** to run validation and build preparation in parallel:

   ```groovy
   stage('Parallel Validation') {
       parallel {
           stage('Check Dockerfile') {
               steps {
                   script {
                       // TODO: Read and validate Dockerfile
                       // TODO: Check for required instructions (FROM, COPY, etc.)
                   }
               }
           }
           
           stage('Check Python Files') {
               steps {
                   script {
                       // TODO: Check if app.py exists
                       // TODO: Check if requirements.txt exists
                   }
               }
           }
           
           stage('Check Dependencies') {
               steps {
                   script {
                       // TODO: List files in application directory
                       // TODO: Verify all required files are present
                   }
               }
           }
       }
   }
   ```

2. **Place this stage** before the "Build" stage.

3. **Commit and push**:
   ```bash
   git add 04-Jenkins/my-pipeline/Jenkinsfile
   git commit -m "Add parallel validation stages"
   git push
   ```

4. **Run pipeline** and observe parallel execution in Jenkins UI.

**Verification**:
- [ ] Parallel stages execute simultaneously
- [ ] All validation checks pass
- [ ] Pipeline execution time reduced (optional benefit)
- [ ] Visual representation shows parallel execution

---

### Task 8: Add Notifications (15 minutes)

**Goal**: Add post-build notifications.

**Instructions**:

1. **Update post section** of your Jenkinsfile:

   ```groovy
   post {
       always {
           script {
               // TODO: Print build summary
               // TODO: List all stages that ran
           }
       }
       success {
           script {
               // TODO: Print success message
               // TODO: Print ECR image URI
               // TODO: Print build duration
           }
       }
       failure {
           script {
               // TODO: Print failure message
               // TODO: Print which stage failed
               // TODO: Suggest troubleshooting steps
           }
       }
       unstable {
           script {
               // TODO: Print warning message
           }
       }
   }
   ```

2. **Add build information**:
   - Build number
   - Build URL
   - ECR image URI (if successful)
   - Build duration
   - Failed stage (if failed)

3. **Commit and push**:
   ```bash
   git add 04-Jenkins/my-pipeline/Jenkinsfile
   git commit -m "Add post-build notifications"
   git push
   ```

**Verification**:
- [ ] Post section updated with all conditions
- [ ] Success message shows ECR URI
- [ ] Failure message shows which stage failed
- [ ] Build information displayed correctly

---

### Task 9: Trigger Pipeline via Webhook (10 minutes)

**Goal**: Set up automatic pipeline triggers on code push.

**Instructions**:

1. **Configure GitHub Webhook**:
   - Go to: GitHub → Your Repository → Settings → Webhooks
   - Click "Add webhook"
   - **Payload URL**: `http://<JENKINS_IP>:8080/github-webhook/`
   - **Content type**: `application/json`
   - **Events**: Select "Just the push event"
   - **Active**: Checked
   - Click "Add webhook"

2. **Verify Jenkins job configuration**:
   - Job should have "GitHub hook trigger" enabled (from Task 2)

3. **Test webhook**:
   ```bash
   # Make a small change
   echo "# Test webhook" >> README.md
   git add README.md
   git commit -m "Test webhook trigger"
   git push
   ```

4. **Verify automatic build**:
   - Check Jenkins dashboard
   - New build should start automatically
   - Verify it's triggered by webhook (check build cause)

**Verification**:
- [ ] Webhook configured in GitHub
- [ ] Webhook delivers successfully (check Recent Deliveries)
- [ ] Jenkins job triggers automatically on push
- [ ] Build starts without manual intervention

---

### Task 10: Cleanup and Documentation (10 minutes)

**Goal**: Document your work and clean up resources.

**Instructions**:

1. **Create a summary document**:
   ```bash
   cd 04-Jenkins/my-pipeline
   cat > CHALLENGE_SUMMARY.md <<EOF
   # Jenkins Challenge Summary
   
   ## Student Name: _______________
   ## Date: _______________
   
   ## ECR Repository
   - Repository Name: _______________
   - Repository URI: _______________
   - Region: _______________
   
   ## Jenkins Job
   - Job Name: _______________
   - Jenkins URL: _______________
   - GitHub Repository: _______________
   
   ## Pipeline Stages
   1. _______________
   2. _______________
   3. _______________
   (List all stages)
   
   ## Build Results
   - Total Builds: _______________
   - Successful Builds: _______________
   - Failed Builds: _______________
   - Latest Build Number: _______________
   
   ## Images in ECR
   - Total Images: _______________
   - Latest Image Tag: _______________
   - Image URI: _______________
   
   ## Challenges Faced
   - _______________
   - _______________
   
   ## Key Learnings
   - _______________
   - _______________
   EOF
   ```

2. **Fill in the summary** with your actual values.

3. **Take screenshots** (optional but recommended):
   - Jenkins pipeline view showing successful build
   - ECR repository with images
   - GitHub webhook configuration
   - Pipeline console output

4. **Commit documentation**:
   ```bash
   git add CHALLENGE_SUMMARY.md
   git commit -m "Add challenge summary"
   git push
   ```

**Verification**:
- [ ] Summary document created
- [ ] All information filled in
- [ ] Documentation committed to repository

---

## 🎓 Bonus Challenges

### Bonus 1: Multi-Environment Pipeline

Create separate pipelines for different environments:
- `Jenkinsfile.dev` - Development pipeline
- `Jenkinsfile.staging` - Staging pipeline  
- `Jenkinsfile.prod` - Production pipeline

Each should have different ECR repositories or tags.

### Bonus 2: Image Scanning

Add a stage that scans Docker images for vulnerabilities:
```groovy
stage('Security Scan') {
    steps {
        script {
            // Use Trivy, Snyk, or AWS ECR scanning
            sh 'trivy image ${DOCKER_IMAGE}'
        }
    }
}
```

### Bonus 3: Slack/Email Notifications

Configure Jenkins to send notifications:
- Success: Send image URI and build info
- Failure: Send error details and troubleshooting tips

### Bonus 4: Pipeline with Approval

Add a manual approval stage before pushing to production:
```groovy
stage('Approval') {
    steps {
        input message: 'Deploy to production?', ok: 'Deploy'
    }
}
```

### Bonus 5: Build Matrix

Build images for multiple architectures or Python versions:
```groovy
matrix {
    axes {
        axis {
            name 'PYTHON_VERSION'
            values '3.9', '3.10', '3.11'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh "docker build --build-arg PYTHON_VERSION=${PYTHON_VERSION} ..."
            }
        }
    }
}
```

---

## ✅ Completion Checklist

Mark each task as you complete it:

### Core Tasks
- [ ] Task 1: ECR repository created
- [ ] Task 2: Jenkins job configured
- [ ] Task 3: Custom Jenkinsfile created
- [ ] Task 4: Pipeline runs successfully
- [ ] Task 5: Images verified in ECR
- [ ] Task 6: Testing stage added
- [ ] Task 7: Parallel stages implemented
- [ ] Task 8: Notifications added
- [ ] Task 9: Webhook triggers working
- [ ] Task 10: Documentation completed

### Bonus Tasks
- [ ] Bonus 1: Multi-environment pipelines
- [ ] Bonus 2: Image scanning
- [ ] Bonus 3: Slack/Email notifications
- [ ] Bonus 4: Manual approval stage
- [ ] Bonus 5: Build matrix

---

## 📊 Self-Assessment

Rate your understanding (1-5):

- [ ] Jenkins setup and configuration: ___/5
- [ ] Pipeline syntax and structure: ___/5
- [ ] GitHub integration: ___/5
- [ ] Docker builds in Jenkins: ___/5
- [ ] AWS ECR integration: ___/5
- [ ] Error handling: ___/5
- [ ] Pipeline optimization: ___/5

---

## 🎯 Key Concepts Demonstrated

This challenge tests your understanding of:

1. **Jenkins Configuration**: Setting up jobs and pipelines
2. **Pipeline as Code**: Writing Jenkinsfiles
3. **GitHub Integration**: Webhooks and SCM
4. **Docker Integration**: Building and testing containers
5. **AWS Integration**: ECR authentication and image pushing
6. **Pipeline Optimization**: Parallel execution
7. **Error Handling**: Graceful failure management
8. **CI/CD Best Practices**: Testing, validation, notifications

---

## 🆘 Troubleshooting Guide

### Pipeline Fails at Checkout

**Problem**: Cannot checkout from GitHub

**Solutions**:
- Verify GitHub credentials in Jenkins
- Check repository URL is correct
- Verify branch name matches
- Check network connectivity

### Docker Build Fails

**Problem**: Permission denied or command not found

**Solutions**:
```bash
# On Jenkins server
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### ECR Login Fails

**Problem**: Authentication error

**Solutions**:
- Verify AWS credentials/IAM role
- Check region is correct
- Verify ECR repository exists
- Test login manually: `aws ecr get-login-password --region us-east-1`

### Webhook Not Triggering

**Problem**: Builds don't start automatically

**Solutions**:
- Check webhook delivery in GitHub
- Verify Jenkins job has webhook trigger enabled
- Check Jenkins is accessible from internet
- Verify security group allows port 8080

### Images Not Appearing in ECR

**Problem**: Push succeeds but images not visible

**Solutions**:
- Check correct repository name
- Verify region matches
- Wait a few seconds and refresh
- Check IAM permissions for ECR

---

## 📝 Submission Guidelines

### What to Submit

1. **Jenkinsfile**: Your complete custom Jenkinsfile
2. **Summary Document**: `CHALLENGE_SUMMARY.md` with all details
3. **Screenshots** (optional):
   - Successful pipeline run
   - ECR repository with images
   - Webhook configuration

### How to Submit

1. **Push to GitHub**:
   ```bash
   git add .
   git commit -m "Complete Jenkins challenge"
   git push
   ```

2. **Share Repository Link**: Provide link to your repository

3. **Share Jenkins Job**: Provide Jenkins job URL (if accessible)

### Evaluation Criteria

Your challenge will be evaluated on:

- ✅ **Functionality**: Pipeline runs end-to-end successfully
- ✅ **Code Quality**: Clean, readable Jenkinsfile
- ✅ **Best Practices**: Error handling, cleanup, optimization
- ✅ **Documentation**: Complete summary and comments
- ✅ **Innovation**: Bonus challenges completed

---

## 🎉 Congratulations!

Upon completing this challenge, you have:

- ✅ Set up a complete CI/CD pipeline
- ✅ Integrated Jenkins with GitHub and AWS
- ✅ Built and pushed Docker images automatically
- ✅ Implemented testing and validation
- ✅ Optimized pipeline performance
- ✅ Demonstrated production-ready skills

**You're now ready for real-world Jenkins CI/CD projects!** 🚀

---

**Good luck with your challenge!** 💪

