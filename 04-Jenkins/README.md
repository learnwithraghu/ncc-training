# Jenkins CI/CD Pipeline Module

Welcome to the Jenkins CI/CD Pipeline module. This module takes a **progressive, ladder approach** to learning Jenkins - starting with setup and gradually building to advanced pipeline patterns.

## 📚 Module Overview

This module provides hands-on experience with:

1. **Jenkins Setup on EC2** - Installing and configuring Jenkins on AWS EC2
2. **First Pipeline** - Creating and understanding basic pipelines
3. **GitHub Integration** - Connecting Jenkins to GitHub repositories
4. **Docker Build Pipeline** - Building Docker images using Jenkins
5. **AWS ECR Integration** - Pushing Docker images to Amazon ECR
6. **Advanced Groovy** - Writing complex pipeline scripts and patterns

## 🗂️ Module Structure

```
04-Jenkins/
├── 00-OVERVIEW.md                    Jenkins theory and concepts
├── README.md                         This file - Module guide
├── 01-jenkins-setup.md               Lesson 1: Setup Jenkins on EC2
├── 02-first-pipeline.md              Lesson 2: Create your first pipeline
├── 03-github-integration.md           Lesson 3: Connect GitHub to Jenkins
├── 04-docker-build.md                Lesson 4: Build Docker images
├── 05-ecr-integration.md             Lesson 5: Push to AWS ECR
├── 06-groovy-advanced.md             Lesson 6: Advanced Groovy patterns
├── scripts/                          Jenkins scripts and configurations
│   ├── Jenkinsfile                   Complete pipeline example
│   ├── jenkins-ec2-setup.sh          EC2 Jenkins installation script
│   ├── ecr-setup.sh                  AWS ECR setup script
│   └── jenkins-plugins.txt            Required Jenkins plugins list
└── examples/                         Additional example Jenkinsfiles
    ├── simple-docker-build.groovy
    └── multi-stage-pipeline.groovy
```

## 🎯 Learning Objectives

By the end of this module, you will be able to:

- [ ] **Install** Jenkins on EC2 instance
- [ ] **Configure** Jenkins with required plugins
- [ ] **Create** basic Jenkins pipelines
- [ ] **Connect** Jenkins to GitHub repositories
- [ ] **Build** Docker images in Jenkins pipelines
- [ ] **Push** Docker images to AWS ECR
- [ ] **Write** advanced Groovy pipeline scripts
- [ ] **Debug** and troubleshoot Jenkins pipelines

## 🚀 Prerequisites

Before starting this module, ensure you have:

### 1. AWS Account Setup

- Active AWS account with appropriate permissions
- AWS CLI installed and configured
- IAM user with permissions for:
  - EC2 (create, manage instances)
  - ECR (create repositories, push/pull images)
  - IAM (create roles and policies)

### 2. AWS CLI Installation

```bash
# macOS
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify installation
aws --version
```

### 3. AWS CLI Configuration

```bash
# Configure AWS credentials
aws configure

# You'll be prompted for:
# AWS Access Key ID: [Your access key]
# AWS Secret Access Key: [Your secret key]
# Default region name: [e.g., us-east-1]
# Default output format: [json]
```

### 4. GitHub Account

- GitHub account with a repository
- Personal Access Token (PAT) for Jenkins integration
- SSH keys configured (optional but recommended)

### 5. Docker Knowledge

- Understanding of Docker basics (complete 03-Docker module first)
- Docker installed locally for testing

## 📖 Progressive Learning Path

This module follows a **ladder approach** - each lesson builds on the previous one. Follow the lessons in order:

### Lesson 1: Jenkins Setup
**File**: [01-jenkins-setup.md](./01-jenkins-setup.md)

- Launch EC2 instance
- Install Jenkins
- Access Jenkins web UI
- Install required plugins
- Basic configuration

**Time**: 30-45 minutes

### Lesson 2: First Pipeline
**File**: [02-first-pipeline.md](./02-first-pipeline.md)

- Understand pipeline concepts
- Create simple pipeline
- Learn pipeline syntax
- Execute and view results
- Basic stages and steps

**Time**: 30-45 minutes

### Lesson 3: GitHub Integration
**File**: [03-github-integration.md](./03-github-integration.md)

- Create GitHub Personal Access Token
- Configure GitHub credentials
- Connect Jenkins to GitHub
- Set up webhooks
- Use Jenkinsfiles from repository

**Time**: 30-45 minutes

### Lesson 4: Docker Build
**File**: [04-docker-build.md](./04-docker-build.md)

- Install Docker on Jenkins server
- Configure Docker permissions
- Build Docker images in pipeline
- Test Docker containers
- Docker build best practices

**Time**: 45-60 minutes

### Lesson 5: ECR Integration
**File**: [05-ecr-integration.md](./05-ecr-integration.md)

- Create ECR repository
- Configure AWS credentials
- Login to ECR
- Tag and push images
- Verify images in ECR

**Time**: 45-60 minutes

### Lesson 6: Advanced Groovy
**File**: [06-groovy-advanced.md](./06-groovy-advanced.md)

- Advanced pipeline patterns
- Parallel execution
- Error handling
- Shared libraries
- Best practices

**Time**: 60-90 minutes

## 🎓 Recommended Learning Schedule

### For Beginners (No Jenkins Experience)

**Week 1:**
- Day 1: Read [00-OVERVIEW.md](./00-OVERVIEW.md) (theory)
- Day 2: Complete [01-jenkins-setup.md](./01-jenkins-setup.md)
- Day 3: Complete [02-first-pipeline.md](./02-first-pipeline.md)

**Week 2:**
- Day 1: Complete [03-github-integration.md](./03-github-integration.md)
- Day 2: Complete [04-docker-build.md](./04-docker-build.md)
- Day 3: Complete [05-ecr-integration.md](./05-ecr-integration.md)

**Week 3:**
- Day 1-2: Study [06-groovy-advanced.md](./06-groovy-advanced.md)
- Day 3: Practice and review

**Total Time**: 12-15 hours

### For Intermediate Users (Some CI/CD Experience)

- Day 1: Skim overview, complete lessons 1-3
- Day 2: Complete lessons 4-5
- Day 3: Study lesson 6, practice advanced patterns

**Total Time**: 6-8 hours

## 📚 Additional Resources

### Scripts and Examples

- **scripts/Jenkinsfile**: Complete pipeline example (builds Docker, pushes to ECR)
- **scripts/jenkins-ec2-setup.sh**: Automated Jenkins installation
- **scripts/ecr-setup.sh**: ECR repository setup script
- **examples/**: Additional pipeline examples

### Quick Reference

Common commands are included in each lesson. For a complete reference, see:
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Groovy Documentation](https://groovy-lang.org/documentation.html)
- [AWS ECR Documentation](https://docs.aws.amazon.com/ecr/)

## 🔧 Troubleshooting

Each lesson includes a troubleshooting section. Common issues:

### Jenkins Not Accessible
- Check security group allows port 8080
- Verify Jenkins service is running
- Check firewall rules

### Docker Permission Denied
- Add jenkins user to docker group
- Restart Jenkins after adding to group

### ECR Login Fails
- Verify AWS credentials are configured
- Check IAM permissions
- Verify region is correct

### GitHub Webhook Not Working
- Check webhook delivery in GitHub
- Verify Jenkins job has webhook trigger enabled
- Check network connectivity

## ✅ Module Completion Checklist

Before moving to the next module, ensure you can:

- [ ] Install Jenkins on EC2
- [ ] Create and run basic pipelines
- [ ] Connect Jenkins to GitHub
- [ ] Build Docker images in pipelines
- [ ] Push images to AWS ECR
- [ ] Write advanced Groovy scripts
- [ ] Troubleshoot common issues

## 🎯 Next Steps After This Module

After completing this module, consider:

- **Kubernetes Integration**: Deploy containers to EKS
- **Advanced CI/CD**: Multi-environment deployments
- **Security**: Implement secrets management, RBAC
- **Monitoring**: Set up Jenkins monitoring and alerting
- **Shared Libraries**: Create reusable pipeline code

## 🤝 Getting Help

**During the Module:**
1. Check troubleshooting sections in each lesson
2. Review Jenkins console output for errors
3. Consult official Jenkins documentation
4. Ask instructor or peers

**Common Commands for Help:**
```bash
# Jenkins logs
sudo tail -f /var/log/jenkins/jenkins.log

# Docker logs
docker logs <container>

# AWS CLI help
aws <service> help
```

---

## 🚀 Ready to Begin?

Start your Jenkins journey with the **theory** in [00-OVERVIEW.md](./00-OVERVIEW.md), then proceed to [01-jenkins-setup.md](./01-jenkins-setup.md) for hands-on setup.

**Remember**: Follow the lessons in order (1 → 2 → 3 → 4 → 5 → 6) for the best learning experience!

**Happy Automating!** 🎉
