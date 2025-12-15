#!/bin/bash

###############################################################################
# AWS ECR Setup Script
# This script creates an ECR repository and configures it for Jenkins
###############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Default values
REPOSITORY_NAME="ncc-training-app"
AWS_REGION="us-east-1"
IMAGE_TAG_MUTABILITY="MUTABLE"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--name)
            REPOSITORY_NAME="$2"
            shift 2
            ;;
        -r|--region)
            AWS_REGION="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -n, --name NAME       ECR repository name (default: ncc-training-app)"
            echo "  -r, --region REGION   AWS region (default: us-east-1)"
            echo "  -h, --help            Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

print_status "=========================================="
print_status "AWS ECR Setup Script"
print_status "=========================================="
print_status "Repository Name: ${REPOSITORY_NAME}"
print_status "AWS Region: ${AWS_REGION}"
print_status ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    print_error "AWS CLI is not installed."
    print_error "Install it with: curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip' && unzip awscliv2.zip && sudo ./aws/install"
    exit 1
fi

# Check AWS credentials
print_status "Checking AWS credentials..."
if ! aws sts get-caller-identity &> /dev/null; then
    print_error "AWS credentials not configured."
    print_error "Run: aws configure"
    exit 1
fi

# Get AWS account ID
print_status "Getting AWS account ID..."
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
if [ -z "$AWS_ACCOUNT_ID" ]; then
    print_error "Failed to get AWS account ID"
    exit 1
fi
print_status "AWS Account ID: ${AWS_ACCOUNT_ID}"

# Check if repository already exists
print_status "Checking if repository exists..."
if aws ecr describe-repositories --repository-names "${REPOSITORY_NAME}" --region "${AWS_REGION}" &> /dev/null; then
    print_warning "Repository '${REPOSITORY_NAME}' already exists."
    read -p "Do you want to continue with existing repository? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Exiting..."
        exit 0
    fi
else
    # Create ECR repository
    print_status "Creating ECR repository..."
    aws ecr create-repository \
        --repository-name "${REPOSITORY_NAME}" \
        --region "${AWS_REGION}" \
        --image-scanning-configuration scanOnPush=true \
        --image-tag-mutability "${IMAGE_TAG_MUTABILITY}" \
        --encryption-configuration encryptionType=AES256
    
    if [ $? -eq 0 ]; then
        print_status "Repository created successfully!"
    else
        print_error "Failed to create repository"
        exit 1
    fi
fi

# Get repository URI
print_status "Getting repository URI..."
REPOSITORY_URI=$(aws ecr describe-repositories \
    --repository-names "${REPOSITORY_NAME}" \
    --region "${AWS_REGION}" \
    --query 'repositories[0].repositoryUri' \
    --output text)

if [ -z "$REPOSITORY_URI" ]; then
    print_error "Failed to get repository URI"
    exit 1
fi

# Display summary
echo ""
print_status "=========================================="
print_status "ECR Setup Complete!"
print_status "=========================================="
echo ""
echo "Repository Details:"
echo "  Name: ${REPOSITORY_NAME}"
echo "  URI: ${REPOSITORY_URI}"
echo "  Region: ${AWS_REGION}"
echo "  Account ID: ${AWS_ACCOUNT_ID}"
echo ""
echo "Use this URI in your Jenkins pipeline:"
echo "  ${REPOSITORY_URI}"
echo ""
echo "Example Docker commands:"
echo "  # Login to ECR"
echo "  aws ecr get-login-password --region ${AWS_REGION} | \\"
echo "    docker login --username AWS --password-stdin ${REPOSITORY_URI}"
echo ""
echo "  # Tag image"
echo "  docker tag myapp:latest ${REPOSITORY_URI}:latest"
echo ""
echo "  # Push image"
echo "  docker push ${REPOSITORY_URI}:latest"
echo ""
echo "Useful Commands:"
echo "  # List images in repository"
echo "  aws ecr list-images --repository-name ${REPOSITORY_NAME} --region ${AWS_REGION}"
echo ""
echo "  # Delete repository (careful!)"
echo "  aws ecr delete-repository --repository-name ${REPOSITORY_NAME} --region ${AWS_REGION} --force"
echo ""
print_status "Setup complete!"

