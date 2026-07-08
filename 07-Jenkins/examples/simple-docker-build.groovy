// Simple Docker Build Pipeline
// This is a basic example that builds a Docker image from the 03-Docker/application directory

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
                    sh "docker build -t ${DOCKER_IMAGE} ."
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
            echo 'Pipeline execution completed'
        }
        success {
            echo "Build succeeded! Image: ${DOCKER_IMAGE}"
        }
        failure {
            echo 'Build failed!'
        }
    }
}

