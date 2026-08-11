#!/usr/bin/env bash
set -euo pipefail

# Jenkins setup for Amazon Linux EC2
# Run as root or with sudo.

sudo dnf update -y
sudo dnf install -y --allowerasing java-17-amazon-corretto git python3 wget

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo wget -qO /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo dnf install -y jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins

sudo systemctl status jenkins --no-pager

echo "Jenkins installed. Open http://<EC2-PUBLIC-IP>:8080 in your browser."
