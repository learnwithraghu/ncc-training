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

Approximately **6-7 hours** total, split into 20 guided topics at about 20 minutes each.

## Prerequisites

- Completion of [Day 2](../00-course-roadmap.md#day-2-git-and-github-basics)
- Docker installed (`docker --version`)

## Guided Learning Topics

Work through the topics in `guided-learning/` in order:

| Topic | Folder | Focus |
|-------|--------|-------|
| Topic 1 | [guided-learning/topic-01/](guided-learning/topic-01/) | Container mindset and quick test |
| Topic 2 | [guided-learning/topic-02/](guided-learning/topic-02/) | Images and layers |
| Topic 3 | [guided-learning/topic-03/](guided-learning/topic-03/) | Run containers and publish ports |
| Topic 4 | [guided-learning/topic-04/](guided-learning/topic-04/) | Environment variables and inspect |
| Topic 5 | [guided-learning/topic-05/](guided-learning/topic-05/) | Logs and exec |
| Topic 6 | [guided-learning/topic-06/](guided-learning/topic-06/) | Volumes and data persistence |
| Topic 7 | [guided-learning/topic-07/](guided-learning/topic-07/) | Bind mounts and app state |
| Topic 8 | [guided-learning/topic-08/](guided-learning/topic-08/) | Build the sample app image |
| Topic 9 | [guided-learning/topic-09/](guided-learning/topic-09/) | Image tagging and lifecycle |
| Topic 10 | [guided-learning/topic-10/](guided-learning/topic-10/) | Healthchecks and restart behavior |
| Topic 11 | [guided-learning/topic-11/](guided-learning/topic-11/) | Docker networking basics |
| Topic 12 | [guided-learning/topic-12/](guided-learning/topic-12/) | Docker Compose basics |
| Topic 13 | [guided-learning/topic-13/](guided-learning/topic-13/) | Compose with the sample app |
| Topic 14 | [guided-learning/topic-14/](guided-learning/topic-14/) | Dockerfile best practices |
| Topic 15 | [guided-learning/topic-15/](guided-learning/topic-15/) | Security and non-root users |
| Topic 16 | [guided-learning/topic-16/](guided-learning/topic-16/) | Multi-stage builds |
| Topic 17 | [guided-learning/topic-17/](guided-learning/topic-17/) | Saving and loading images |
| Topic 18 | [guided-learning/topic-18/](guided-learning/topic-18/) | Troubleshooting containers |
| Topic 19 | [guided-learning/topic-19/](guided-learning/topic-19/) | Full app workflow |
| Topic 20 | [guided-learning/topic-20/](guided-learning/topic-20/) | Docker mini workflow |

## Getting Started

Verify Docker is installed:

```bash
docker --version
docker info
```

If Docker is not installed, ask your instructor to help you get it running before starting the topics.

### Quick Docker Test

Verify your Docker installation:

```bash
docker run hello-world
```

If this works, you're ready to start the guided topics.

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

### Guided Learning
- [guided-learning/](guided-learning/) - 20 self-contained Docker topics

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

## Guided Learning Focus

The topic guides replace the old guide, exercise, solution, and lab flow. Each lesson is self-contained and designed to take about 20 minutes.
