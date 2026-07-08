# Lesson 4: Building Docker Images with Jenkins

This lesson covers building Docker images in Jenkins pipelines. You'll learn how to install Docker on Jenkins server, configure permissions, and create pipelines that build Docker images.

## Learning Objectives

- Install Docker on Jenkins server
- Configure Docker permissions for Jenkins user
- Build Docker images in pipelines
- Test Docker images in pipelines
- Understand Docker build best practices

## Prerequisites

- Jenkins installed and running (Lesson 1)
- Jenkins connected to Gitea (Lesson 3)
- Basic Docker knowledge (from Module 3)
- Understanding of Dockerfiles

## Step 1: Install Docker on Jenkins Server

### SSH into Jenkins Server

```bash
ssh -i your-key-pair.pem ubuntu@<JENKINS_IP>
```

### Install Docker

```bash
# Install Docker using official script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Verify installation
docker --version
docker info
```

### Add Jenkins User to Docker Group

This allows Jenkins to run Docker commands without sudo:

```bash
# Add jenkins user to docker group
sudo usermod -aG docker jenkins

# Verify group membership
groups jenkins

# Restart Jenkins to apply changes
sudo systemctl restart jenkins

# Wait for Jenkins to restart
sleep 10

# Verify Jenkins can access Docker
sudo -u jenkins docker --version
```

### Verify Docker Installation

```bash
# Test Docker
sudo docker run hello-world

# Check Docker service
sudo systemctl status docker
```

## Step 2: Create a Simple Docker Build Pipeline

### Basic Docker Build Pipeline

Create a new pipeline job or update existing one:

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
                echo 'Checking out code from Gitea...'
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
            echo 'Build completed'
        }
    }
}
```

### Understanding the Pipeline

- **`environment`**: Defines variables used throughout pipeline
- **`dir()`**: Changes to specified directory
- **`docker build`**: Builds image from Dockerfile
- **`docker tag`**: Tags image with version and latest

## Step 3: Test Docker Image in Pipeline

### Enhanced Pipeline with Testing

```groovy
pipeline {
    agent any
    
    environment {
        APP_NAME = 'ncc-training-app'
        DOCKER_IMAGE = "${APP_NAME}:${BUILD_NUMBER}"
        CONTAINER_NAME = "${APP_NAME}-test-${BUILD_NUMBER}"
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
        
        stage('Test') {
            steps {
                script {
                    try {
                        echo 'Starting container for testing...'
                        sh """
                            docker run -d --name ${CONTAINER_NAME} -p 5000:5000 ${DOCKER_IMAGE}
                            sleep 5
                        """
                        
                        echo 'Running health check...'
                        sh 'curl -f http://localhost:5000/health || exit 1'
                        
                        echo 'Testing main endpoint...'
                        def response = sh(
                            script: 'curl -s http://localhost:5000/',
                            returnStdout: true
                        ).trim()
                        echo "Response: ${response}"
                        
                        echo '✅ All tests passed!'
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
        }
    }
}
```

## Step 4: Validate Dockerfile Before Building

### Pipeline with Validation

```groovy
pipeline {
    agent any
    
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
                    
                    // Check for required instructions
                    if (!dockerfile.contains('FROM')) {
                        error('Dockerfile is invalid: missing FROM instruction')
                    }
                    
                    if (!dockerfile.contains('COPY') && !dockerfile.contains('ADD')) {
                        error('Dockerfile is invalid: missing COPY or ADD instruction')
                    }
                    
                    echo '✅ Dockerfile validation passed'
                }
            }
        }
        
        stage('Build') {
            steps {
                dir('03-Docker/application') {
                    sh 'docker build -t myapp:${BUILD_NUMBER} .'
                }
            }
        }
    }
}
```

## Step 5: Docker Build Best Practices

### Use Build Cache

```groovy
stage('Build with Cache') {
    steps {
        script {
            // Try to pull previous image for cache
            try {
                sh 'docker pull myapp:latest || true'
            } catch (Exception e) {
                echo 'No previous image found, building from scratch'
            }
            
            // Build with cache
            dir('03-Docker/application') {
                sh """
                    docker build \
                        --cache-from myapp:latest \
                        -t myapp:${BUILD_NUMBER} \
                        -t myapp:latest \
                        .
                """
            }
        }
    }
}
```

### Build Arguments

```groovy
stage('Build with Arguments') {
    steps {
        dir('03-Docker/application') {
            sh """
                docker build \
                    --build-arg VERSION=${BUILD_NUMBER} \
                    --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
                    -t myapp:${BUILD_NUMBER} \
                    .
            """
        }
    }
}
```

### Multi-Stage Builds

If your Dockerfile uses multi-stage builds:

```groovy
stage('Build Multi-Stage') {
    steps {
        dir('03-Docker/application') {
            sh """
                docker build \
                    --target production \
                    -t myapp:${BUILD_NUMBER} \
                    .
            """
        }
    }
}
```

## Step 6: Clean Up Docker Resources

### Cleanup Stage

```groovy
post {
    always {
        script {
            // Remove test containers
            sh 'docker ps -aq --filter name=myapp-test | xargs -r docker rm -f || true'
            
            // Remove old images (keep last 5)
            sh '''
                docker images myapp --format "{{.ID}}" | \
                tail -n +6 | \
                xargs -r docker rmi || true
            '''
            
            // Prune unused resources
            sh 'docker system prune -f || true'
        }
    }
}
```

## Step 7: Practice Exercise

### Exercise: Build and Test Pipeline

Create a pipeline that:

1. Checks out code
2. Validates Dockerfile exists
3. Builds Docker image with tag `test-app:${BUILD_NUMBER}`
4. Runs container and tests health endpoint
5. Lists all images with name `test-app`
6. Cleans up test container

**Solution**:

```groovy
pipeline {
    agent any
    
    environment {
        APP_NAME = 'test-app'
        IMAGE_TAG = "${APP_NAME}:${BUILD_NUMBER}"
        CONTAINER_NAME = "${APP_NAME}-${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Validate') {
            steps {
                script {
                    if (!fileExists('03-Docker/application/Dockerfile')) {
                        error('Dockerfile not found!')
                    }
                    echo '✅ Dockerfile found'
                }
            }
        }
        
        stage('Build') {
            steps {
                dir('03-Docker/application') {
                    sh "docker build -t ${IMAGE_TAG} ."
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    try {
                        sh """
                            docker run -d --name ${CONTAINER_NAME} -p 5000:5000 ${IMAGE_TAG}
                            sleep 5
                            curl -f http://localhost:5000/health
                        """
                        echo '✅ Health check passed'
                    } finally {
                        sh "docker stop ${CONTAINER_NAME} || true"
                        sh "docker rm ${CONTAINER_NAME} || true"
                    }
                }
            }
        }
        
        stage('List Images') {
            steps {
                sh "docker images | grep ${APP_NAME}"
            }
        }
    }
    
    post {
        always {
            sh "docker stop ${CONTAINER_NAME} || true"
            sh "docker rm ${CONTAINER_NAME} || true"
        }
    }
}
```

## Troubleshooting

### Permission Denied

**Problem**: `permission denied while trying to connect to Docker daemon`

**Solution**:
```bash
# Add jenkins user to docker group
sudo usermod -aG docker jenkins

# Restart Jenkins
sudo systemctl restart jenkins

# Verify
sudo -u jenkins docker ps
```

### Docker Not Found

**Problem**: `docker: command not found`

**Solution**:
```bash
# Install Docker (see Step 1)
# Or add Docker to PATH
export PATH=$PATH:/usr/bin
```

### Build Fails

**Problem**: Docker build fails

**Solutions**:
- Check Dockerfile syntax
- Verify all files exist (COPY commands)
- Check Docker daemon is running: `sudo systemctl status docker`
- View detailed logs in Jenkins console output

### Port Already in Use

**Problem**: `port is already allocated`

**Solution**:
```groovy
// Use dynamic port or stop existing containers
sh 'docker stop $(docker ps -q --filter publish=5000) || true'
```

## Key Takeaways

✅ **Docker Installation**: Install Docker on Jenkins server  
✅ **Permissions**: Add jenkins user to docker group  
✅ **Build Images**: Use `docker build` in pipeline  
✅ **Test Images**: Run containers and test endpoints  
✅ **Cleanup**: Always clean up containers and images  
✅ **Best Practices**: Use cache, build args, validation  

## Next Steps

Great progress! You can now build Docker images in Jenkins.

**In the next lesson**, you'll learn how to push Docker images to AWS ECR.

**Before moving on**, make sure:
- ✅ Docker installed on Jenkins server
- ✅ Jenkins user can run Docker commands
- ✅ You can build Docker images in pipeline
- ✅ You can test Docker containers in pipeline

---

**Ready for the next lesson?** Move to [05-ecr-integration.md](./05-ecr-integration.md) to push images to AWS ECR!

