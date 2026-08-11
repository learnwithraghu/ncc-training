#!/bin/bash
set -e

yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd

PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || echo "unknown")
echo "Hello this is EC2 instance and public IP: ${PUBLIC_IP}" > /var/www/html/index.html
