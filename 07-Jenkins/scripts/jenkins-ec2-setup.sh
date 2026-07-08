#!/bin/bash

###############################################################################
# Jenkins EC2 Setup Script
# This script installs and configures Jenkins on an Ubuntu EC2 instance
###############################################################################

set -e  # Exit on error

echo "=========================================="
echo "Jenkins EC2 Setup Script"
echo "=========================================="

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

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_error "Please run as root or with sudo"
    exit 1
fi

print_status "Starting Jenkins installation..."

# Update system packages
print_status "Updating system packages..."
apt update
apt upgrade -y

# Install required packages
print_status "Installing required packages..."
apt install -y \
    curl \
    wget \
    git \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install Java (Jenkins requires Java 11 or 17)
print_status "Installing Java 17..."
apt install -y openjdk-17-jdk

# Verify Java installation
JAVA_VERSION=$(java -version 2>&1 | head -n 1)
print_status "Java installed: ${JAVA_VERSION}"

# Add Jenkins repository key
print_status "Adding Jenkins repository key..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
    tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins repository
print_status "Adding Jenkins repository..."
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | \
    tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list
print_status "Updating package list..."
apt update

# Install Jenkins
print_status "Installing Jenkins..."
apt install -y jenkins

# Start and enable Jenkins
print_status "Starting Jenkins service..."
systemctl start jenkins
systemctl enable jenkins

# Wait for Jenkins to start
print_status "Waiting for Jenkins to start..."
sleep 10

# Check Jenkins status
if systemctl is-active --quiet jenkins; then
    print_status "Jenkins is running!"
else
    print_error "Jenkins failed to start. Check logs: journalctl -u jenkins"
    exit 1
fi

# Get initial admin password
INITIAL_PASSWORD=$(cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || echo "NOT_FOUND")

# Get instance IP
INSTANCE_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || hostname -I | awk '{print $1}')

# Install Docker (optional but recommended)
print_status "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh

# Add jenkins user to docker group
print_status "Adding jenkins user to docker group..."
usermod -aG docker jenkins

# Install Docker Compose (optional)
print_status "Installing Docker Compose..."
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install AWS CLI
print_status "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

# Configure firewall (if ufw is installed)
if command -v ufw &> /dev/null; then
    print_status "Configuring firewall..."
    ufw allow 22/tcp
    ufw allow 8080/tcp
    ufw --force enable
fi

# Restart Jenkins to apply docker group changes
print_status "Restarting Jenkins to apply changes..."
systemctl restart jenkins

# Wait for Jenkins to restart
sleep 10

# Display summary
echo ""
echo "=========================================="
echo "Jenkins Installation Complete!"
echo "=========================================="
echo ""
echo "Jenkins URL: http://${INSTANCE_IP}:8080"
echo ""
if [ "$INITIAL_PASSWORD" != "NOT_FOUND" ]; then
    echo "Initial Admin Password: ${INITIAL_PASSWORD}"
    echo ""
    print_warning "Save this password! You'll need it to unlock Jenkins."
else
    print_warning "Could not retrieve initial admin password."
    print_warning "Run: sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
fi
echo ""
echo "Next Steps:"
echo "1. Open http://${INSTANCE_IP}:8080 in your browser"
echo "2. Enter the initial admin password"
echo "3. Install suggested plugins"
echo "4. Create an admin user"
echo "5. Configure Jenkins URL"
echo ""
echo "Useful Commands:"
echo "  - Check Jenkins status: sudo systemctl status jenkins"
echo "  - View Jenkins logs: sudo journalctl -u jenkins -f"
echo "  - Restart Jenkins: sudo systemctl restart jenkins"
echo "  - Get admin password: sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo ""
print_status "Setup complete!"

