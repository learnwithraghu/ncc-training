# Day 3, Part 1: Docker

This module covers containerization with Docker.

## What You Will Learn

By the end of this module, you will be able to:

- Explain what containers are and why they matter
- Build Docker images from Dockerfiles
- Run, stop, and inspect containers
- Manage container networking and volumes
- Apply Docker best practices

## Time Estimate

Approximately **4 hours** (including hands-on exercises).

## Prerequisites

- Completion of [Day 2](../00-course-roadmap.md#day-2-git-and-github-basics)
- Docker installed (`docker --version`)

## Guide Sequence

| Guide | File | Topic | Duration |
|-------|------|-------|----------|
| Guide 1 | [00-OVERVIEW.md](00-OVERVIEW.md) | Container theory and concepts | 30 min |
| Guide 2 | [01-docker-basics.md](01-docker-basics.md) | Hello World, images, containers | 60 min |
| Guide 3 | [02-volumes-and-storage.md](02-volumes-and-storage.md) | Volumes and bind mounts | 45 min |
| Guide 4 | [03-networking.md](03-networking.md) | Container networking | 45 min |
| Guide 5 | [04-container-operations.md](04-container-operations.md) | Logs, exec, debugging | 45 min |
| Guide 6 | [05-best-practices.md](05-best-practices.md) | Production practices | 30 min |

## Day 3 Narrative

You will take the Python app from your `ncc-labs` GitHub repository and containerize it. The Docker image you build today will be pushed to ECR by your CI/CD pipeline on Day 4.

## Key Artifact

A working Docker image for a Python Flask application.

## Getting Started

Verify Docker is installed:

```bash
docker --version
docker info
```

If Docker is not installed, ask your instructor or follow the installation steps in [00-OVERVIEW.md](00-OVERVIEW.md).

### Quick Docker Test

Verify your Docker installation:

```bash
# Run hello-world container
docker run hello-world

# Expected output: "Hello from Docker!"
```

If this works, you're ready to proceed!

## 📖 Recommended Learning Path

### For Beginners (No Docker Experience)

1. **Start with theory**: Read [00-OVERVIEW.md](./00-OVERVIEW.md) thoroughly
   - Understand containers vs VMs
   - Learn Docker architecture
   - Grasp why Docker matters for DevOps

2. **Hands-on basics**: Work through [01-docker-basics.md](./01-docker-basics.md)
   - Inspect the sample application
   - Build your first Docker image
   - Run and test containers

3. **Data management**: Follow [02-volumes-and-storage.md](./02-volumes-and-storage.md)
   - Understand volume concepts
   - Practice data persistence
   - Learn bind mounts vs named volumes

4. **Networking**: Study [03-networking.md](./03-networking.md)
   - Explore Docker networks
   - Connect multiple containers
   - Understand service discovery

5. **Operations**: Practice [04-container-operations.md](./04-container-operations.md)
   - View and follow logs
   - Access running containers
   - Debug common issues

6. **Best practices**: Review [05-best-practices.md](./05-best-practices.md)
   - Learn production patterns
   - Understand security implications  
   - Optimize Dockerfiles

7. **Challenge yourself**: Complete [lab-exercises/LAB_CHALLENGE.md](./lab-exercises/LAB_CHALLENGE.md)
   - Apply everything you've learned
   - Solve real-world scenarios

### For Intermediate Users (Some Docker Experience)

1. Skim [00-OVERVIEW.md](./00-OVERVIEW.md) to fill knowledge gaps
2. Quickly review [01-docker-basics.md](./01-docker-basics.md)
3. Focus on [05-best-practices.md](./05-best-practices.md) for production patterns
4. Jump to [lab-exercises/](./lab-exercises/) to test your skills

### Estimated Time

- **Beginners**: 4-6 hours (including hands-on exercises)
- **Intermediate**: 2-3 hours (focused on advanced topics)
- **Review/Refresher**: 1 hour (best practices and lab challenge)

## 🛠️ Sample Application

This module uses a Python Flask web application to demonstrate Docker concepts. The app provides:

**Endpoints:**
- `/` - Main endpoint with container info
- `/health` - Health check
- `/info` - Detailed container information
- `/write` - Write data to demonstrate volumes
- `/read` - Read persisted data

**Purpose:**
- Simple enough to understand quickly
- Complex enough to demonstrate real Docker features
- Includes logging, health checks, and data persistence

**Location:** `application/` directory

## 📚 Additional Resources

### Official Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

### Quick References
- [QUICK_REFERENCE.md](./reference/QUICK_REFERENCE.md) - Common Docker commands
- [TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md) - Common issues and solutions

### Next Steps After This Module
- **Container Orchestration**: Kubernetes, Docker Swarm
- **CI/CD Integration**: Jenkins, GitHub Actions, GitLab CI
- **Cloud Platforms**: AWS ECS, Google Cloud Run, Azure Container Instances
- **Advanced Topics**: Multi-stage builds, BuildKit, Docker Compose

## 💡 Tips for Success

**Practice Regularly:**
- Run through examples multiple times
- Experiment with modifications
- Break things and fix them (best way to learn!)

**Use Reference Materials:**
- Keep QUICK_REFERENCE.md open while practicing
- Consult TROUBLESHOOTING.md when stuck
- Use `docker <command> --help` for quick help

**Build Real Projects:**
- Containerize your own applications
- Start simple (static websites, basic APIs)
- Gradually increase complexity

**Join the Community:**
- Docker Community Forums
- Stack Overflow `docker` tag
- DevOps community discussions

## 🎓 Certification & Further Learning

After mastering this module, consider:

**Certifications:**
- Docker Certified Associate (DCA)
- Certified Kubernetes Application Developer (CKAD)
- AWS Certified DevOps Engineer

**Advanced Topics:**
- Docker Compose for multi-container applications
- Docker Swarm for clustering
- Kubernetes for production orchestration
- Service mesh technologies (Istio, Linkerd)

## 🤝 Getting Help

**During the Module:**
1. Check [TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md) first
2. Review [QUICK_REFERENCE.md](./reference/QUICK_REFERENCE.md)
3. Examine Docker logs: `docker logs <container>`
4. Consult instructor or peers
5. Search official Docker documentation

**Common Commands for Help:**
```bash
# Get help for any command
docker <command> --help

# Examples
docker run --help
docker build --help
docker volume --help
```

## ✅ Module Completion Checklist

Before moving to the next module, ensure you can:

Technical Skills:
- [ ] Write a Dockerfile from scratch
- [ ] Build and run containers successfully
- [ ] Mount volumes for data persistence
- [ ] Create and use Docker networks
- [ ] View and interpret container logs
- [ ] Access containers for debugging
- [ ] Apply security best practices

Conceptual Understanding:
- [ ] Explain how containers differ from VMs
- [ ] Describe Docker's layered architecture
- [ ] Understand when to use volumes vs bind mounts
- [ ] Explain Docker networking modes
- [ ] Describe Docker's role in CI/CD

Practical Application:
- [ ] Complete the lab challenge successfully
- [ ] Containerize a simple application
- [ ] Debug a failing container
- [ ] Optimize a Dockerfile

---

## 🐳 Ready to Begin?

Start your containerization journey with [00-OVERVIEW.md](./00-OVERVIEW.md) to build a solid theoretical foundation, then dive into hands-on exercises!

Remember: Docker skills are among the most in-demand in DevOps. The time you invest here will pay dividends throughout your career.

**Happy Containerizing!**
