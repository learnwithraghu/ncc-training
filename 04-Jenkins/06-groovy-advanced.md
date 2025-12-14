# Lesson 6: Advanced Groovy Pipeline Patterns

This lesson covers advanced Groovy pipeline patterns and best practices. You'll learn complex pipeline structures, parallel execution, error handling, and production-ready patterns. All examples use the `ncc-training` repository structure.

## 📚 Table of Contents

1. [Pipeline Basics](#pipeline-basics)
2. [Declarative Pipeline Examples](#declarative-pipeline-examples)
3. [Scripted Pipeline Examples](#scripted-pipeline-examples)
4. [Docker Integration](#docker-integration)
5. [AWS ECR Integration](#aws-ecr-integration)
6. [Advanced Patterns](#advanced-patterns)
7. [Best Practices](#best-practices)

## Pipeline Basics

### Declarative vs Scripted Pipelines

**Declarative Pipeline** (Recommended):
- Simpler syntax
- Easier to read and maintain
- Built-in error handling
- Better IDE support

**Scripted Pipeline**:
- More flexibility
- Full Groovy scripting power
- Better for complex logic

### Basic Pipeline Structure

```groovy
pipeline {
    agent any
    
    stages {
        stage('Stage Name') {
            steps {
                // Commands here
            }
        }
    }
    
    post {
        always {
            // Always execute
        }
        success {
            // On success
        }
        failure {
            // On failure
        }
    }
}
```

## Declarative Pipeline Examples

### Example 1: Simple Docker Build

This example builds the Docker image from the `03-Docker/application` directory.

```groovy
pipeline {
    agent any
    
    environment {
        APP_NAME = 'ncc-training-app'
        DOCKER_IMAGE = "${APP_NAME}:${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                dir('03-Docker/application') {
                    sh """
                        docker build -t ${DOCKER_IMAGE} .
                        docker tag ${DOCKER_IMAGE} ${APP_NAME}:latest
                    """
                }
            }
        }
        
        stage('List Images') {
            steps {
                sh 'docker images | grep ${APP_NAME}'
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline execution completed'
            cleanWs()
        }
        success {
            echo 'Build succeeded!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
```

### Example 2: Docker Build with Testing

Adds a test stage before building the Docker image.

```groovy
pipeline {
    agent any
    
    environment {
        APP_NAME = 'ncc-training-app'
        DOCKER_IMAGE = "${APP_NAME}:${BUILD_NUMBER}"
        CONTAINER_NAME = "${APP_NAME}-${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Validate Dockerfile') {
            steps {
                script {
                    def dockerfile = readFile('03-Docker/application/Dockerfile')
                    if (!dockerfile.contains('FROM')) {
                        error('Dockerfile is invalid: missing FROM instruction')
                    }
                    echo 'Dockerfile validation passed'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                dir('03-Docker/application') {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        
        stage('Test Container') {
            steps {
                script {
                    try {
                        sh """
                            docker run -d --name ${CONTAINER_NAME} -p 5000:5000 ${DOCKER_IMAGE}
                            sleep 5
                            curl -f http://localhost:5000/health || exit 1
                        """
                    } finally {
                        sh "docker stop ${CONTAINER_NAME} || true"
                        sh "docker rm ${CONTAINER_NAME} || true"
                    }
                }
            }
        }
    }
    
    post {
        always {
            sh "docker stop ${CONTAINER_NAME} || true"
            sh "docker rm ${CONTAINER_NAME} || true"
            cleanWs()
        }
    }
}
```

### Example 3: Complete ECR Pipeline

Full pipeline with GitHub checkout, Docker build, and ECR push.

```groovy
pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '123456789012'  // Replace with your account ID
        ECR_REPOSITORY = 'ncc-training-app'
        APP_NAME = 'ncc-training-app'
        DOCKER_IMAGE = "${APP_NAME}:${BUILD_NUMBER}"
        ECR_IMAGE = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${BUILD_NUMBER}"
        ECR_IMAGE_LATEST = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:latest"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                dir('03-Docker/application') {
                    sh """
                        docker build -t ${DOCKER_IMAGE} .
                        docker tag ${DOCKER_IMAGE} ${APP_NAME}:latest
                    """
                }
            }
        }
        
        stage('Login to ECR') {
            steps {
                script {
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin \
                        ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    """
                }
            }
        }
        
        stage('Tag and Push to ECR') {
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
        
        stage('Verify Push') {
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
            echo 'Cleaning up local Docker images...'
            sh """
                docker rmi ${DOCKER_IMAGE} || true
                docker rmi ${APP_NAME}:latest || true
                docker rmi ${ECR_IMAGE} || true
                docker rmi ${ECR_IMAGE_LATEST} || true
            """
            cleanWs()
        }
        success {
            echo "Successfully pushed ${ECR_IMAGE} to ECR"
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
```

### Example 4: Multi-Branch Pipeline

Handles different branches with conditional logic.

```groovy
pipeline {
    agent any
    
    environment {
        APP_NAME = 'ncc-training-app'
        DOCKER_IMAGE = "${APP_NAME}:${BRANCH_NAME}-${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                dir('03-Docker/application') {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        
        stage('Conditional Push to ECR') {
            when {
                anyOf {
                    branch 'main'
                    branch 'master'
                }
            }
            steps {
                script {
                    def AWS_ACCOUNT_ID = '123456789012'
                    def AWS_REGION = 'us-east-1'
                    def ECR_REPOSITORY = 'ncc-training-app'
                    def ECR_IMAGE = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${BRANCH_NAME}-${BUILD_NUMBER}"
                    
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin \
                        ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                        
                        docker tag ${DOCKER_IMAGE} ${ECR_IMAGE}
                        docker push ${ECR_IMAGE}
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo "Build ${BUILD_NUMBER} on branch ${BRANCH_NAME} succeeded"
        }
    }
}
```

## Scripted Pipeline Examples

### Example 5: Scripted Pipeline with Error Handling

```groovy
node {
    def APP_NAME = 'ncc-training-app'
    def DOCKER_IMAGE = "${APP_NAME}:${BUILD_NUMBER}"
    
    try {
        stage('Checkout') {
            checkout scm
        }
        
        stage('Build') {
            dir('03-Docker/application') {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }
        
        stage('Test') {
            def containerName = "${APP_NAME}-test-${BUILD_NUMBER}"
            try {
                sh """
                    docker run -d --name ${containerName} -p 5000:5000 ${DOCKER_IMAGE}
                    sleep 5
                """
                
                def response = sh(
                    script: "curl -s http://localhost:5000/health",
                    returnStdout: true
                ).trim()
                
                if (!response.contains('healthy')) {
                    error('Health check failed')
                }
                
                echo "Health check passed: ${response}"
            } finally {
                sh "docker stop ${containerName} || true"
                sh "docker rm ${containerName} || true"
            }
        }
        
        stage('Push to ECR') {
            def AWS_ACCOUNT_ID = '123456789012'
            def AWS_REGION = 'us-east-1'
            def ECR_REPOSITORY = 'ncc-training-app'
            def ECR_IMAGE = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${BUILD_NUMBER}"
            
            sh """
                aws ecr get-login-password --region ${AWS_REGION} | \
                docker login --username AWS --password-stdin \
                ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                
                docker tag ${DOCKER_IMAGE} ${ECR_IMAGE}
                docker push ${ECR_IMAGE}
            """
        }
        
        echo 'Pipeline completed successfully'
    } catch (Exception e) {
        echo "Pipeline failed: ${e.getMessage()}"
        currentBuild.result = 'FAILURE'
        throw e
    } finally {
        // Cleanup
        sh "docker rmi ${DOCKER_IMAGE} || true"
        cleanWs()
    }
}
```

### Example 6: Parallel Execution

```groovy
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Parallel Build and Test') {
            parallel {
                stage('Build Docker Image') {
                    steps {
                        dir('03-Docker/application') {
                            sh 'docker build -t ncc-app:${BUILD_NUMBER} .'
                        }
                    }
                }
                
                stage('Validate Files') {
                    steps {
                        script {
                            def files = [
                                '03-Docker/application/Dockerfile',
                                '03-Docker/application/app.py',
                                '03-Docker/application/requirements.txt'
                            ]
                            
                            files.each { file ->
                                if (!fileExists(file)) {
                                    error("Required file missing: ${file}")
                                }
                                echo "✓ ${file} exists"
                            }
                        }
                    }
                }
            }
        }
        
        stage('Integration Test') {
            steps {
                script {
                    def containerName = "ncc-app-test-${BUILD_NUMBER}"
                    try {
                        sh """
                            docker run -d --name ${containerName} -p 5000:5000 ncc-app:${BUILD_NUMBER}
                            sleep 5
                        """
                        
                        // Test multiple endpoints
                        sh 'curl -f http://localhost:5000/health'
                        sh 'curl -f http://localhost:5000/'
                        sh 'curl -f http://localhost:5000/info'
                        
                        echo 'All integration tests passed'
                    } finally {
                        sh "docker stop ${containerName} || true"
                        sh "docker rm ${containerName} || true"
                    }
                }
            }
        }
    }
}
```

## Docker Integration

### Example 7: Multi-Stage Docker Build

```groovy
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build with Cache') {
            steps {
                dir('03-Docker/application') {
                    script {
                        // Try to pull previous image for cache
                        try {
                            sh 'docker pull ncc-app:latest || true'
                        } catch (Exception e) {
                            echo 'No previous image found, building from scratch'
                        }
                        
                        // Build with cache
                        sh """
                            docker build \
                                --cache-from ncc-app:latest \
                                -t ncc-app:${BUILD_NUMBER} \
                                -t ncc-app:latest \
                                .
                        """
                    }
                }
            }
        }
    }
}
```

### Example 8: Docker Compose Integration

If you have a docker-compose.yml file:

```groovy
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build with Docker Compose') {
            steps {
                dir('03-Docker/application') {
                    sh 'docker-compose build'
                }
            }
        }
        
        stage('Test with Docker Compose') {
            steps {
                dir('03-Docker/application') {
                    sh 'docker-compose up -d'
                    sleep(time: 10, unit: 'SECONDS')
                    sh 'curl -f http://localhost:5000/health'
                    sh 'docker-compose down'
                }
            }
        }
    }
}
```

## AWS ECR Integration

### Example 9: ECR with Credentials Management

```groovy
pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY = 'ncc-training-app'
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
                    def accountId = sh(
                        script: 'aws sts get-caller-identity --query Account --output text',
                        returnStdout: true
                    ).trim()
                    env.AWS_ACCOUNT_ID = accountId
                    env.ECR_REGISTRY = "${accountId}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                    echo "Using ECR registry: ${env.ECR_REGISTRY}"
                }
            }
        }
        
        stage('Build') {
            steps {
                dir('03-Docker/application') {
                    sh "docker build -t ${ECR_REPOSITORY}:${BUILD_NUMBER} ."
                }
            }
        }
        
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
        
        stage('Push to ECR') {
            steps {
                script {
                    def imageTag = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${BUILD_NUMBER}"
                    def latestTag = "${ECR_REGISTRY}/${ECR_REPOSITORY}:latest"
                    
                    sh """
                        docker tag ${ECR_REPOSITORY}:${BUILD_NUMBER} ${imageTag}
                        docker tag ${ECR_REPOSITORY}:${BUILD_NUMBER} ${latestTag}
                        docker push ${imageTag}
                        docker push ${latestTag}
                    """
                    
                    // Store image URI for downstream jobs
                    env.ECR_IMAGE_URI = imageTag
                }
            }
        }
    }
    
    post {
        success {
            echo "Image pushed: ${env.ECR_IMAGE_URI}"
        }
    }
}
```

### Example 10: ECR with Image Scanning

```groovy
pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY = 'ncc-training-app'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build and Push') {
            steps {
                script {
                    def accountId = sh(
                        script: 'aws sts get-caller-identity --query Account --output text',
                        returnStdout: true
                    ).trim()
                    def imageTag = "${accountId}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${BUILD_NUMBER}"
                    
                    dir('03-Docker/application') {
                        sh "docker build -t ${imageTag} ."
                    }
                    
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin \
                        ${accountId}.dkr.ecr.${AWS_REGION}.amazonaws.com
                        
                        docker push ${imageTag}
                    """
                }
            }
        }
        
        stage('Wait for Scan') {
            steps {
                script {
                    def accountId = sh(
                        script: 'aws sts get-caller-identity --query Account --output text',
                        returnStdout: true
                    ).trim()
                    def imageTag = "${ECR_REPOSITORY}:${BUILD_NUMBER}"
                    
                    echo 'Waiting for ECR image scan to complete...'
                    sleep(time: 30, unit: 'SECONDS')
                    
                    def scanResult = sh(
                        script: """
                            aws ecr describe-image-scan-findings \
                                --repository-name ${ECR_REPOSITORY} \
                                --image-id imageTag=${imageTag} \
                                --region ${AWS_REGION} \
                                --query 'imageScanFindings.findingCounts' \
                                --output json
                        """,
                        returnStdout: true
                    ).trim()
                    
                    echo "Scan results: ${scanResult}"
                }
            }
        }
    }
}
```

## Advanced Patterns

### Example 11: Shared Library Usage

If you have a Jenkins shared library:

```groovy
@Library('my-shared-library') _

pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                script {
                    def dockerImage = buildDockerImage(
                        dockerfilePath: '03-Docker/application/Dockerfile',
                        imageName: 'ncc-app',
                        tag: "${BUILD_NUMBER}"
                    )
                    
                    pushToECR(
                        image: dockerImage,
                        repository: 'ncc-training-app',
                        region: 'us-east-1'
                    )
                }
            }
        }
    }
}
```

### Example 12: Pipeline with Notifications

```groovy
pipeline {
    agent any
    
    environment {
        SLACK_CHANNEL = '#jenkins-notifications'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                dir('03-Docker/application') {
                    sh 'docker build -t ncc-app:${BUILD_NUMBER} .'
                }
            }
        }
    }
    
    post {
        success {
            script {
                def message = """
                    ✅ Build #${BUILD_NUMBER} succeeded
                    Branch: ${BRANCH_NAME}
                    Commit: ${GIT_COMMIT.take(7)}
                """
                // slackSend channel: SLACK_CHANNEL, color: 'good', message: message
                echo message
            }
        }
        failure {
            script {
                def message = """
                    ❌ Build #${BUILD_NUMBER} failed
                    Branch: ${BRANCH_NAME}
                    Check: ${BUILD_URL}
                """
                // slackSend channel: SLACK_CHANNEL, color: 'danger', message: message
                echo message
            }
        }
    }
}
```

## Best Practices

### 1. Use Environment Variables

```groovy
environment {
    // Don't hardcode values
    AWS_REGION = 'us-east-1'
    ECR_REPOSITORY = 'ncc-training-app'
    
    // Use build variables
    IMAGE_TAG = "${BUILD_NUMBER}"
    BRANCH_TAG = "${BRANCH_NAME}-${BUILD_NUMBER}"
}
```

### 2. Error Handling

```groovy
stage('Build') {
    steps {
        script {
            try {
                sh 'docker build -t myapp:${BUILD_NUMBER} .'
            } catch (Exception e) {
                echo "Build failed: ${e.getMessage()}"
                // Cleanup
                sh 'docker system prune -f'
                throw e
            }
        }
    }
}
```

### 3. Resource Cleanup

```groovy
post {
    always {
        script {
            // Always cleanup containers
            sh 'docker ps -aq | xargs -r docker rm -f || true'
            
            // Cleanup old images (keep last 5)
            sh '''
                docker images ncc-app --format "{{.ID}}" | \
                tail -n +6 | \
                xargs -r docker rmi || true
            '''
        }
        cleanWs()
    }
}
```

### 4. Conditional Stages

```groovy
stage('Deploy to Production') {
    when {
        branch 'main'
        expression { 
            return env.BUILD_NUMBER.toInteger() % 10 == 0 
        }
    }
    steps {
        echo 'Deploying to production...'
    }
}
```

### 5. Timeout and Retry

```groovy
stage('Build') {
    steps {
        retry(3) {
            timeout(time: 10, unit: 'MINUTES') {
                sh 'docker build -t myapp:${BUILD_NUMBER} .'
            }
        }
    }
}
```

## 📝 Using These Examples

1. **Copy to Jenkinsfile**: Save any example as `Jenkinsfile` in your repository
2. **Update Variables**: Replace placeholder values (AWS account ID, region, etc.)
3. **Test Locally**: Use Jenkins Pipeline Linter or test in Jenkins
4. **Iterate**: Start simple, add complexity as needed

## 🔗 Additional Resources

- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Groovy Documentation](https://groovy-lang.org/documentation.html)
- [Docker Pipeline Plugin](https://plugins.jenkins.io/docker-workflow/)
- [AWS Steps Plugin](https://plugins.jenkins.io/pipeline-aws/)

---

**Ready to build your pipeline?** Start with Example 3 (Complete ECR Pipeline) and customize it for your needs!

