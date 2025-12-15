# Zero to Hero: DevOps Training Course

**A comprehensive, hands-on journey from Linux fundamentals to containerization**

## 🎯 Course Overview

This course is designed to take you from complete beginner to confident DevOps practitioner. You'll build foundational skills in Linux, master version control with Git, and learn containerization with Docker—the three pillars of modern DevOps practices.

### Who Is This Course For?

- **Complete beginners**: No prior DevOps or Linux experience needed
- **Developers**: Looking to understand deployment and operations
- **System administrators**: Transitioning to DevOps practices
- **Students**: Building foundational skills for tech careers
- **Career changers**: Entering the DevOps field

### What You'll Learn

By the end of this course, you will:

✅ Navigate and manage Linux systems confidently  
✅ Write bash scripts to automate repetitive tasks  
✅ Use Git for version control and team collaboration  
✅ Implement branching strategies for different workflows  
✅ Build and deploy containerized applications with Docker  
✅ Set up CI/CD pipelines with Jenkins  
✅ Integrate Jenkins with GitHub and AWS ECR  
✅ Deploy and manage applications with Kubernetes  
✅ Configure services, storage, and networking in K8s  
✅ Apply DevOps best practices for security and performance

## 📚 Course Structure

The course is organized into five progressive modules, each building on the previous:

```
ncc-train/
├── 01-Linux/                Linux fundamentals and bash scripting
├── 02-Git/                  Version control and collaboration
├── 03-Docker/               Containerization and deployment
├── 04-Jenkins/              CI/CD pipelines and automation
├── 05-Kubernetes/           Container orchestration
└── README.md               This file
```

---

## 📖 Module 1: Linux Fundamentals

**Directory:** [01-Linux/](./01-Linux/)

**Duration:** 4-5 hours (including exercises)

### What You'll Learn

- Linux architecture and file system hierarchy
- Command-line navigation and file management
- Text editors (vim basics)
- System monitoring and process management
- Bash scripting fundamentals
- Permission model and user management

### Module Contents

| File | Description |
|------|-------------|
| [00-OVERVIEW.md](./01-Linux/00-OVERVIEW.md) | Comprehensive Linux theory (1800+ words) |
| [01-introduction.md](./01-Linux/01-introduction.md) | Basic navigation and commands |
| [02-file-management.md](./01-Linux/02-file-management.md) | Files, directories, and permissions |
| [03-text-editors.md](./01-Linux/03-text-editors.md) | Vim basics |
| [04-system-management.md](./01-Linux/04-system-management.md) | System monitoring and processes |
| [05-bash-scripting-basics.md](./01-Linux/05-bash-scripting-basics.md) | Writing bash scripts |
| [06-advanced-exercises.md](./01-Linux/06-advanced-exercises.md) | Advanced topics |
| [07-challenges/](./01-Linux/07-challenges/) | Hands-on challenges |

### Learning Path

1. Read [00-OVERVIEW](./01-Linux/00-OVERVIEW.md) for theoretical foundation
2. Follow modules 01-06 in sequence with hands-on practice
3. Complete challenges in [07-challenges/](./01-Linux/07-challenges/)

### Prerequisites

- Access to a terminal (Linux, macOS, or WSL on Windows)
- Willingness to experiment and learn from mistakes

---

## 📖 Module 2: Git and Version Control

**Directory:** [02-Git/](./02-Git/)

**Duration:** 3-4 hours (including workshop)

### What You'll Learn

- Version control fundamentals
- Git architecture and workflow
- Branching strategies (Git Flow, GitHub Flow, Trunk-Based)
- Code review and collaboration best practices
- CI/CD integration with Git
- Managing secrets and credentials

### Module Contents

| File | Description |
|------|-------------|
| [00-OVERVIEW.md](./02-Git/00-OVERVIEW.md) | Comprehensive version control theory (2000+ words) |
| [01-git-basics-workshop.md](./02-Git/01-git-basics-workshop.md) | Hands-on Git workshop |
| [02-branching-strategies.md](./02-Git/02-branching-strategies.md) | Branching strategies comparison |
| [03-best-practices.md](./02-Git/03-best-practices.md) | Commit messages, PRs, code reviews |

### Learning Path

1. Read [00-OVERVIEW](./02-Git/00-OVERVIEW.md) to understand version control concepts
2. Complete [01-git-basics-workshop](./02-Git/01-git-basics-workshop.md) hands-on
3. Study [02-branching-strategies](./02-Git/02-branching-strategies.md) for team workflows
4. Review [03-best-practices](./02-Git/03-best-practices.md) for professional development

### Prerequisites

- Git installed locally
- GitHub account (free)
- Completion of Module 1 (Linux) recommended

---

## 📖 Module 3: Docker Containerization

**Directory:** [03-Docker/](./03-Docker/)

**Duration:** 4-6 hours (including lab challenge)

### What You'll Learn

- Containerization fundamentals
- Docker architecture (images, containers, layers)
- Building and optimizing Docker images
- Data persistence with volumes
- Container networking
- Security best practices
- CI/CD pipeline integration

### Module Contents

| Path | Description |
|------|-------------|
| [00-OVERVIEW.md](./03-Docker/00-OVERVIEW.md) | Comprehensive containerization theory (2200+ words) |
| [01-docker-basics.md](./03-Docker/01-docker-basics.md) | Building and running containers |
| [02-volumes-and-storage.md](./03-Docker/02-volumes-and-storage.md) | Data persistence |
| [03-networking.md](./03-Docker/03-networking.md) | Container networking |
| [04-container-operations.md](./03-Docker/04-container-operations.md) | Logs and debugging |
| [05-best-practices.md](./03-Docker/05-best-practices.md) | Production practices and security |
| [application/](./03-Docker/application/) | Sample Python Flask app |
| [lab-exercises/](./03-Docker/lab-exercises/) | Comprehensive lab challenge |
| [reference/](./03-Docker/reference/) | Quick reference and troubleshooting |

### Learning Path

1. Read [00-OVERVIEW](./03-Docker/00-OVERVIEW.md) for containerization concepts
2. Work through modules 01-04, practicing with the sample application
3. Study [05-best-practices](./03-Docker/05-best-practices.md) for production skills
4. Complete [lab-exercises](./03-Docker/lab-exercises/) to solidify knowledge

### Prerequisites

- Docker installed locally
- Completion of Modules 1 and 2 recommended
- Basic understanding of applications and services

---

## 📖 Module 4: Jenkins CI/CD Pipelines

**Directory:** [04-Jenkins/](./04-Jenkins/)

**Duration:** 4-6 hours (including setup and practice)

### What You'll Learn

- Jenkins architecture and concepts
- Setting up Jenkins on AWS EC2
- Connecting GitHub repositories to Jenkins
- Building Docker images with Jenkins pipelines
- Pushing images to AWS ECR
- Writing Groovy pipeline scripts
- CI/CD best practices

### Module Contents

| Path | Description |
|------|-------------|
| [00-OVERVIEW.md](./04-Jenkins/00-OVERVIEW.md) | Jenkins theory and concepts |
| [README.md](./04-Jenkins/README.md) | Module guide and learning path |
| [01-jenkins-setup.md](./04-Jenkins/01-jenkins-setup.md) | Lesson 1: Setup Jenkins on EC2 |
| [02-first-pipeline.md](./04-Jenkins/02-first-pipeline.md) | Lesson 2: Create your first pipeline |
| [03-github-integration.md](./04-Jenkins/03-github-integration.md) | Lesson 3: Connect GitHub to Jenkins |
| [04-docker-build.md](./04-Jenkins/04-docker-build.md) | Lesson 4: Build Docker images |
| [05-ecr-integration.md](./04-Jenkins/05-ecr-integration.md) | Lesson 5: Push to AWS ECR |
| [06-groovy-advanced.md](./04-Jenkins/06-groovy-advanced.md) | Lesson 6: Advanced Groovy patterns |
| [scripts/](./04-Jenkins/scripts/) | Jenkinsfiles and setup scripts |
| [examples/](./04-Jenkins/examples/) | Additional pipeline examples |

### Learning Path

Follow lessons in progressive order (ladder approach):

1. Read [00-OVERVIEW](./04-Jenkins/00-OVERVIEW.md) for Jenkins concepts
2. Complete [01-jenkins-setup.md](./04-Jenkins/01-jenkins-setup.md) - Setup Jenkins
3. Complete [02-first-pipeline.md](./04-Jenkins/02-first-pipeline.md) - First pipeline
4. Complete [03-github-integration.md](./04-Jenkins/03-github-integration.md) - GitHub connection
5. Complete [04-docker-build.md](./04-Jenkins/04-docker-build.md) - Docker builds
6. Complete [05-ecr-integration.md](./04-Jenkins/05-ecr-integration.md) - ECR push
7. Study [06-groovy-advanced.md](./04-Jenkins/06-groovy-advanced.md) - Advanced patterns

### Prerequisites

- AWS account with EC2 and ECR access
- GitHub account and repository
- Completion of Module 3 (Docker) required
- Basic understanding of CI/CD concepts

---

## 📖 Module 5: Kubernetes Container Orchestration

**Directory:** [05-Kubernetes/](./05-Kubernetes/)

**Duration:** 5-6 hours (including hands-on practice)

### What You'll Learn

- Kubernetes architecture and core concepts
- Pod and deployment management
- Services and networking configuration
- Persistent storage and configuration management
- StatefulSets, Jobs, and CronJobs
- Resource management and health checks
- Helm package management
- Production best practices

### Module Contents

| Path | Description |
|------|-------------|
| [00-OVERVIEW.md](./05-Kubernetes/00-OVERVIEW.md) | Comprehensive K8s theory and architecture |
| [README.md](./05-Kubernetes/README.md) | Module guide with all commands |
| [01-basics.md](./05-Kubernetes/01-basics.md) | **Level 1:** Cluster basics and kubectl |
| [02-pods-deployments.md](./05-Kubernetes/02-pods-deployments.md) | **Level 2:** Pods, deployments, scaling |
| [03-services-networking.md](./05-Kubernetes/03-services-networking.md) | **Level 3:** Services, ingress, networking |
| [04-storage-config.md](./05-Kubernetes/04-storage-config.md) | **Level 4:** Volumes, ConfigMaps, Secrets |
| [05-advanced.md](./05-Kubernetes/05-advanced.md) | **Level 5:** StatefulSets, Jobs, Helm |
| `level-01-basics/` | Scripts and manifests for Level 1 |
| `level-02-pods-deployments/` | Scripts and manifests for Level 2 |
| `level-03-services-networking/` | Scripts and manifests for Level 3 |
| `level-04-storage-config/` | Scripts and manifests for Level 4 |
| `level-05-advanced/` | Scripts and manifests for Level 5 |

### Learning Path

Follow the ladder approach (0 to hero):

1. Read [00-OVERVIEW](./05-Kubernetes/00-OVERVIEW.md) for K8s concepts
2. Complete [01-basics.md](./05-Kubernetes/01-basics.md) - Cluster basics
3. Complete [02-pods-deployments.md](./05-Kubernetes/02-pods-deployments.md) - Application deployment
4. Complete [03-services-networking.md](./05-Kubernetes/03-services-networking.md) - Networking
5. Complete [04-storage-config.md](./05-Kubernetes/04-storage-config.md) - Storage & config
6. Complete [05-advanced.md](./05-Kubernetes/05-advanced.md) - Advanced patterns

### Prerequisites

- Kubernetes cluster running (Minikube, Kind, or cloud-based)
- kubectl installed and configured
- Completion of Module 3 (Docker) required
- Completion of Module 4 (Jenkins) recommended

---

## 🎓 Learning Philosophy

### Hands-On First

This course emphasizes **learning by doing**:
- Each concept includes practical exercises
- Real-world examples and scenarios
- Challenges that reinforce learning
- Progressive complexity (0 to hero!)

### Comprehensive Theory

Each module includes extensive theoretical coverage (1000+ words):
- **Why** things work the way they do
- **How** concepts fit into DevOps practices
- **When** to apply different techniques
- **Real-world** use cases and patterns

### Best Practices Embedded

From day one, you'll learn industry best practices:
- Security-first approach
- Automation mindset
- Professional workflows
- Production-ready skills

---

## 🚀 Getting Started

### 1. Verify Prerequisites

**For Linux Module:**
```bash
# Verify terminal access
pwd
ls
```

**For Git Module:**
```bash
# Verify Git installation
git --version
```

**For Docker Module:**
```bash
# Verify Docker installation
docker --version
docker run hello-world
```

### 2. Choose Your Path

**Sequential (Recommended for Beginners):**
1. Complete 01-Linux fully
2. Then 02-Git
3. Then 03-Docker
4. Then 04-Jenkins
5. Finally 05-Kubernetes

**Selective (For Experienced Users):**
- Skip to modules where you need practice
- Use overview files to fill knowledge gaps
- Focus on best practices sections

### 3. Pace Yourself

This is a **self-paced course**:
- Take breaks between sessions
- Practice commands multiple times
- Don't rush through theory
- Complete all hands-on exercises

**Recommended Schedule:**
- **Week 1**: Linux Fundamentals (2-3 sessions)
- **Week 2**: Git and Version Control (2 sessions)
- **Week 3**: Docker Containerization (3-4 sessions)
- **Week 4**: Jenkins CI/CD Pipelines (3-4 sessions)
- **Week 5**: Kubernetes Container Orchestration (3-4 sessions)

---

## 💡 Study Tips

### For Maximum Learning

1. **Don't just read—type every command**: Muscle memory matters
2. **Break things intentionally**: Learn from errors
3. **Complete all challenges**: They reinforce concepts
4. **Take notes**: Especially on error messages and solutions
5. **Build real projects**: Apply skills beyond course exercises

### When You're Stuck

1. **Check module's troubleshooting guide** (if available)
2. **Review the overview** for conceptual understanding
3. **Use help commands**: `man`, `--help`, `git help`
4. **Search error messages**: Stack Overflow, official docs
5. **Ask for help**: Community forums, instructors

### Common Pitfalls to Avoid

- **Skipping theory**: Understanding **why** is as important as **how**
- **Not practicing enough**: Reading ≠ Learning ≠ Mastery
- **Rushing through**: DevOps skills need time to develop
- **Neglecting best practices**: Bad habits are hard to break

---

## 🎯 Course Completion Criteria

You've successfully completed this course when you can:

### Linux Skills
- [ ] Navigate file system without hesitation
- [ ] Create and modify files with command-line editors
- [ ] Write bash scripts to automate tasks
- [ ] Understand and modify file permissions
- [ ] Monitor system resources and processes

### Git Skills
- [ ] Create and clone repositories
- [ ] Make commits with meaningful messages
- [ ] Create and merge branches
- [ ] Conduct code reviews via pull requests
- [ ] Resolve merge conflicts
- [ ] Choose appropriate branching strategies

### Docker Skills
- [ ] Build Docker images from Dockerfiles
- [ ] Run containers with proper configuration
- [ ] Manage data persistence with volumes
- [ ] Configure container networking
- [ ] Debug containers using logs and shell access
- [ ] Apply security best practices
- [ ] Optimize images for production

### Jenkins Skills
- [ ] Install and configure Jenkins on EC2
- [ ] Connect Jenkins to GitHub repositories
- [ ] Create and run Jenkins pipelines
- [ ] Build Docker images in Jenkins
- [ ] Push images to AWS ECR
- [ ] Write Groovy pipeline scripts
- [ ] Troubleshoot pipeline issues

### Kubernetes Skills
- [ ] Verify and manage Kubernetes clusters
- [ ] Deploy applications with pods and deployments
- [ ] Scale applications horizontally
- [ ] Configure services and networking
- [ ] Manage persistent storage with PVs and PVCs
- [ ] Use ConfigMaps and Secrets
- [ ] Implement health checks and resource limits
- [ ] Deploy stateful applications with StatefulSets
- [ ] Use Helm for package management

---

## 🔗 Additional Resources

### Official Documentation
- [Linux Documentation Project](https://www.tldp.org/)
- [Git Documentation](https://git-scm.com/doc)
- [Docker Documentation](https://docs.docker.com/)

### Community Resources
- [Stack Overflow](https://stackoverflow.com/) - Q&A for technical issues
- [DevOps Subreddit](https://www.reddit.com/r/devops/) - Community discussions
- [Docker Community Forums](https://forums.docker.com/) - Docker-specific help

### Recommended Next Steps
- **Infrastructure as Code**: Terraform, Ansible
- **Container Orchestration**: Kubernetes
- **CI/CD Platforms**: GitHub Actions, GitLab CI, CircleCI
- **Cloud Platforms**: AWS, Google Cloud, Azure
- **Monitoring**: Prometheus, Grafana
- **Advanced Jenkins**: Shared Libraries, Kubernetes integration

---

## 📝 Course Notes

### Module Numbering

The `01-`, `02-`, `03-` prefixes indicate:
- **Learning sequence**: Follow in order for optimal learning
- **Dependency chain**: Each builds on previous modules
- **Progressive complexity**: Start simple, advance gradually

### File Naming Convention

- `00-OVERVIEW.md`: Comprehensive theoretical foundation
- `01-`, `02-`, etc.: Sequential lessons within the module
- `README.md`: Module introduction and guide
- Subfolders: Related materials (challenges, exercises, references)

### Time Estimates

Time estimates include:
- Reading and understanding theory
- Hands-on practice with all commands
- Completing exercises and challenges
- Reviewing and troubleshooting

Your actual time may vary based on prior experience and learning pace.

---

## 🤝 Feedback and Contribution

### For Students

This is a living course. As you progress:
- Note confusing sections
- Suggest improvements
- Share what worked well
- Report errors or typos

### For Instructors

These materials are designed for:
- Self-paced learning
- Classroom instruction
- Workshop formats
- Corporate training

Each module includes instructor notes where applicable.

---

## ✅ Final Checklist

Before starting, ensure you have:

- [ ] Terminal/command line access
- [ ] Text editor installed
- [ ] Git installed (for Module 2)
- [ ] Docker installed (for Module 3)
- [ ] AWS account (for Module 4)
- [ ] GitHub account (for Module 4)
- [ ] Kubernetes cluster access (for Module 5)
- [ ] kubectl installed (for Module 5)
- [ ] Dedicated study time (4-5 weeks recommended)
- [ ] Notebook for taking notes
- [ ] Willingness to experiment and make mistakes

---

## 🎉 Ready to Begin?

Your DevOps journey starts with Linux fundamentals. Head to [01-Linux/](./01-Linux/) and begin with the comprehensive overview.

Remember: Every expert was once a beginner who didn't give up. The time you invest in these foundational skills will pay dividends throughout your entire DevOps career.

**Good luck, and happy learning!** 🚀

---

*Course Version: 1.0*  
*Last Updated: December 2025*
