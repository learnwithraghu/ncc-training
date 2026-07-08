# Day 4, Part 1: Jenkins

This module covers CI/CD with Jenkins.

## What You Will Learn

By the end of this module, you will be able to:

- Install and configure Jenkins
- Create freestyle and pipeline jobs
- Connect Jenkins to Git repositories
- Build Docker images in Jenkins
- Push Docker images to Amazon ECR

## Time Estimate

Approximately **4 hours** (including hands-on exercises).

## Prerequisites

- Completion of [Day 3](../00-course-roadmap.md#day-3-docker-and-docker-compose)
- Jenkins instance (provided by instructor or installed on EC2)
- AWS account and ECR access

## Guide Sequence

| Guide | File | Topic | Duration |
|-------|------|-------|----------|
| Guide 1 | [00-OVERVIEW.md](00-OVERVIEW.md) | Jenkins theory and concepts | 30 min |
| Guide 2 | [01-jenkins-setup.md](01-jenkins-setup.md) | Jenkins setup on EC2 | 60 min |
| Guide 3 | [02-first-pipeline.md](02-first-pipeline.md) | First pipeline | 45 min |
| Guide 4 | [03-gitea-integration.md](03-gitea-integration.md) | Gitea integration | 45 min |
| Guide 5 | [04-docker-build.md](04-docker-build.md) | Docker build pipeline | 60 min |
| Guide 6 | [05-ecr-integration.md](05-ecr-integration.md) | Push to ECR | 60 min |

## Day 4 Narrative

You will set up Jenkins to build the Docker image from your `ncc-labs` repository and push it to Amazon ECR. Later in the day, you will build the same pipeline in GitHub Actions to compare the two CI/CD tools.

## Key Artifact

A Jenkins pipeline that builds and pushes a Docker image to ECR.

## Existing Content

This module reuses the original Jenkins content. The folder structure includes:

- `scripts/` — Jenkinsfiles and setup scripts
- `examples/` — Additional pipeline examples
- `jenkins-challenge.md` — Advanced challenge
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

### Lesson 3: Gitea Integration
**File**: [03-gitea-integration.md](./03-gitea-integration.md)

- Create Gitea Application Token
- Configure Gitea credentials
- Connect Jenkins to Gitea
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

### Gitea Webhook Not Working
- Check webhook delivery in Gitea
- Verify Jenkins job has webhook trigger enabled
- Check network connectivity

## ✅ Module Completion Checklist

Before moving to the next module, ensure you can:

- [ ] Install Jenkins on EC2
- [ ] Create and run basic pipelines
- [ ] Connect Jenkins to Gitea
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
