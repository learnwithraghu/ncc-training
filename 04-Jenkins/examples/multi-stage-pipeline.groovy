// Multi-Stage Pipeline with Testing and ECR Push
// This example demonstrates a complete CI/CD pipeline with multiple stages

pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY = 'ncc-training-app'
        APP_NAME = 'ncc-training-app'
        DOCKER_IMAGE = "${APP_NAME}:${BUILD_NUMBER}"
        CONTAINER_NAME = "${APP_NAME}-test-${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
                sh 'git log -1 --oneline'
            }
        }
        
        stage('Validate') {
            parallel {
                stage('Check Dockerfile') {
                    steps {
                        script {
                            def dockerfile = readFile('03-Docker/application/Dockerfile')
                            if (!dockerfile.contains('FROM')) {
                                error('Dockerfile is invalid')
                            }
                            echo '✓ Dockerfile is valid'
                        }
                    }
                }
                
                stage('Check Python Files') {
                    steps {
                        script {
                            if (!fileExists('03-Docker/application/app.py')) {
                                error('app.py not found')
                            }
                            if (!fileExists('03-Docker/application/requirements.txt')) {
                                error('requirements.txt not found')
                            }
                            echo '✓ All required files exist'
                        }
                    }
                }
            }
        }
        
        stage('Build') {
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
                        
                        echo 'Testing info endpoint...'
                        sh 'curl -f http://localhost:5000/info || exit 1'
                        
                        echo '✓ All tests passed'
                    } finally {
                        sh "docker stop ${CONTAINER_NAME} || true"
                        sh "docker rm ${CONTAINER_NAME} || true"
                    }
                }
            }
        }
        
        stage('Get AWS Account') {
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
                        echo "Warning: AWS not configured, skipping ECR push"
                        env.SKIP_ECR = 'true'
                    }
                }
            }
        }
        
        stage('ECR Login') {
            when {
                expression { return env.SKIP_ECR != 'true' }
            }
            steps {
                script {
                    echo 'Logging into ECR...'
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin ${env.ECR_REGISTRY}
                    """
                }
            }
        }
        
        stage('Push to ECR') {
            when {
                expression { return env.SKIP_ECR != 'true' }
            }
            steps {
                script {
                    def ecrImage = "${env.ECR_REGISTRY}/${ECR_REPOSITORY}:${BUILD_NUMBER}"
                    def ecrImageLatest = "${env.ECR_REGISTRY}/${ECR_REPOSITORY}:latest"
                    
                    echo "Tagging and pushing to ECR..."
                    sh """
                        docker tag ${DOCKER_IMAGE} ${ecrImage}
                        docker tag ${DOCKER_IMAGE} ${ecrImageLatest}
                        docker push ${ecrImage}
                        docker push ${ecrImageLatest}
                    """
                    
                    env.ECR_IMAGE_URI = ecrImage
                    echo "✓ Pushed: ${ecrImage}"
                }
            }
        }
        
        stage('Verify') {
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
                // Cleanup
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
            }
            cleanWs()
        }
        success {
            echo '========================================'
            echo 'Pipeline completed successfully!'
            if (env.ECR_IMAGE_URI) {
                echo "ECR Image: ${env.ECR_IMAGE_URI}"
            }
            echo '========================================'
        }
        failure {
            echo '========================================'
            echo 'Pipeline failed!'
            echo '========================================'
        }
    }
}

