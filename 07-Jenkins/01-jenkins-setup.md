# Lesson 1: Setting Up Jenkins on EC2

This lesson covers installing and configuring Jenkins on an AWS EC2 instance. By the end of this lesson, you'll have a working Jenkins server accessible via web browser.

## Learning Objectives

- Launch an EC2 instance for Jenkins
- Install Jenkins on Ubuntu
- Access Jenkins web interface
- Install required plugins
- Configure basic Jenkins settings

## Prerequisites

- AWS account with EC2 access
- AWS CLI installed and configured
- Basic knowledge of EC2 and SSH

## Step 1: Launch EC2 Instance

### Create Security Group

```bash
# Create a security group for Jenkins
aws ec2 create-security-group \
    --group-name jenkins-sg \
    --description "Security group for Jenkins server"

# Add inbound rules (allow SSH and Jenkins web UI)
aws ec2 authorize-security-group-ingress \
    --group-name jenkins-sg \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name jenkins-sg \
    --protocol tcp \
    --port 8080 \
    --cidr 0.0.0.0/0
```

### Launch EC2 Instance

```bash
# Find latest Ubuntu 22.04 AMI ID for your region
aws ec2 describe-images \
    --owners 099720109477 \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" \
    --query 'Images[*].[ImageId,CreationDate]' \
    --output table | sort -k2 -r | head -1

# Launch EC2 instance (replace AMI ID with the one from above)
aws ec2 run-instances \
    --image-id ami-0c55b159cbfafe1f0 \
    --instance-type t2.medium \
    --key-name your-key-pair \
    --security-groups jenkins-sg \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Jenkins-Server}]'
```

**Note:** 
- Replace `ami-0c55b159cbfafe1f0` with the latest Ubuntu AMI ID for your region
- Replace `your-key-pair` with your actual EC2 key pair name
- `t2.medium` is recommended (2 vCPU, 4GB RAM) for Jenkins

## Step 2: SSH into EC2 Instance

```bash
# Get your instance public IP
aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=Jenkins-Server" \
    --query 'Reservations[*].Instances[*].[PublicIpAddress,State.Name]' \
    --output table

# SSH into the instance (replace <PUBLIC_IP> and key file path)
ssh -i your-key-pair.pem ubuntu@<PUBLIC_IP>
```

## Step 3: Install Jenkins

You have two options: use the automated script or install manually.

### Option A: Automated Installation (Recommended)

```bash
# On your local machine, copy the script to EC2
scp -i your-key-pair.pem scripts/jenkins-ec2-setup.sh ubuntu@<PUBLIC_IP>:~/

# SSH into instance
ssh -i your-key-pair.pem ubuntu@<PUBLIC_IP>

# Make script executable and run
chmod +x jenkins-ec2-setup.sh
sudo ./jenkins-ec2-setup.sh
```

The script will:
- Update system packages
- Install Java 17
- Install Jenkins
- Install Docker and AWS CLI
- Configure firewall
- Display the initial admin password

### Option B: Manual Installation

```bash
# Update system
sudo apt update
sudo apt upgrade -y

# Install Java (Jenkins requires Java 11 or 17)
sudo apt install openjdk-17-jdk -y
java -version

# Add Jenkins repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt update
sudo apt install jenkins -y

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Check Jenkins status
sudo systemctl status jenkins

# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

## Step 4: Access Jenkins Web UI

1. **Open browser** and navigate to: `http://<EC2_PUBLIC_IP>:8080`

2. **Unlock Jenkins**: Enter the initial admin password from Step 3

3. **Install Suggested Plugins**: Click "Install suggested plugins"
   - This will install commonly used plugins
   - Wait for installation to complete (5-10 minutes)

4. **Create Admin User**:
   - Username: `admin` (or your choice)
   - Password: Create a strong password
   - Full name: Your name
   - Email: Your email

5. **Configure Jenkins URL**: 
   - Use the default: `http://<EC2_PUBLIC_IP>:8080/`
   - Or configure a domain if you have one

6. **Click "Save and Finish"** → **Start using Jenkins**

## Step 5: Install Required Plugins

After initial setup, install additional plugins needed for this course:

1. **Go to**: Manage Jenkins → Plugins → Available

2. **Search and install**:
   - **Git** - Git integration
   - **GitHub** - GitHub integration
   - **Pipeline** - Pipeline plugin (usually pre-installed)
   - **Docker Pipeline** - Docker integration
   - **AWS Steps** - AWS integration
   - **Blue Ocean** (optional) - Modern UI

3. **Or use command line** (on Jenkins server):
```bash
# View plugin list
cat scripts/jenkins-plugins.txt

# Install via Jenkins CLI (if configured)
# Note: This requires Jenkins CLI setup
```

4. **Restart Jenkins** after installing plugins:
   - Manage Jenkins → System → Restart Jenkins

## Step 6: Verify Installation

### Check Jenkins Status

```bash
# On Jenkins server
sudo systemctl status jenkins
```

### Test Jenkins Web UI

- Open `http://<EC2_PUBLIC_IP>:8080`
- You should see the Jenkins dashboard
- Try creating a test job to verify everything works

### Verify Plugins

- Go to: Manage Jenkins → Plugins → Installed
- Verify required plugins are installed

## Common Issues and Solutions

### Jenkins Not Accessible

**Problem**: Can't access Jenkins on port 8080

**Solutions**:
```bash
# Check if Jenkins is running
sudo systemctl status jenkins

# Check firewall
sudo ufw status
sudo ufw allow 8080

# Check security group rules
aws ec2 describe-security-groups --group-names jenkins-sg
```

### Forgot Admin Password

```bash
# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Or reset admin password (if you have access)
# Manage Jenkins → Configure Global Security → Enable security
```

### Jenkins Service Not Starting

```bash
# Check logs
sudo journalctl -u jenkins -f

# Check Java installation
java -version

# Restart Jenkins
sudo systemctl restart jenkins
```

## Next Steps

Congratulations! You now have Jenkins installed and running. 

**In the next lesson**, you'll create your first Jenkins pipeline to understand how pipelines work.

**Before moving on**, make sure:
- ✅ Jenkins is accessible via web browser
- ✅ You can log in to Jenkins
- ✅ Required plugins are installed
- ✅ Jenkins is running: `sudo systemctl status jenkins`

## Key Commands Reference

```bash
# Start Jenkins
sudo systemctl start jenkins

# Stop Jenkins
sudo systemctl stop jenkins

# Restart Jenkins
sudo systemctl restart jenkins

# Check Jenkins status
sudo systemctl status jenkins

# View Jenkins logs
sudo tail -f /var/log/jenkins/jenkins.log

# Get admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

**Ready for the next lesson?** Move to [02-first-pipeline.md](./02-first-pipeline.md) to create your first Jenkins pipeline!

