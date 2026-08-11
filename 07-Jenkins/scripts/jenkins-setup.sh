#!/usr/bin/env bash
set -euo pipefail

# Jenkins setup for Ubuntu Server
# Run as root or with sudo.

sudo apt-get update -y
sudo apt-get install -y openjdk-17-jre git python3 wget curl gnupg ca-certificates
sudo mkdir -p /etc/apt/keyrings
sudo wget -qO- https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo gpg --dearmor | sudo tee /etc/apt/keyrings/jenkins-keyring.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins

sudo systemctl status jenkins --no-pager

echo "Jenkins installed. Open http://<EC2-PUBLIC-IP>:8080 in your browser."
