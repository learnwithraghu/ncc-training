# Day 3, Part 1: Docker

This module covers containerization with Docker. You work entirely on an Amazon Linux 2 EC2 instance: install Docker, master `docker build`, run and debug a container, then push the image to Amazon ECR.

This module stops after ECR push.

## What You Will Learn

By the end of this module, you will be able to:

- Install Docker on Amazon Linux 2 EC2
- Build an image from a Dockerfile with `docker build`
- Run a container and publish ports
- Read logs and exec into a running container
- Tag images and inspect what you built
- Push an image from EC2 to Amazon ECR

## Time Estimate

Approximately **2 hours** total, split into 6 topics at about 20 minutes each.

## Prerequisites

- Completion of [Day 2](../00-course-roadmap.md#day-2-git-and-github-basics)
- An Amazon Linux 2 EC2 instance you can SSH into as `ec2-user`
- An IAM instance profile on that EC2 instance with permission to push to ECR (no access keys)
- An ECR repository already created in `us-east-1` (instructor creates this in the AWS Console)

See [demo-infra-requirement.md](demo-infra-requirement.md) for the full checklist.

## Guided Learning Topics

Work through the topics in `new-style/` in order. Each topic teaches a few commands, then gives you a **Task** to try on your own.

| Topic | Folder | Focus |
|-------|--------|-------|
| 01 Setup Docker on EC2 | [new-style/01-setup-docker-on-ec2/](new-style/01-setup-docker-on-ec2/) | SSH to Amazon Linux 2, install Docker, run `hello-world` |
| 02 Docker Build | [new-style/02-docker-build/](new-style/02-docker-build/) | Read the Dockerfile and master `docker build` |
| 03 Docker Run and Ports | [new-style/03-docker-run-and-ports/](new-style/03-docker-run-and-ports/) | Run the image and publish ports |
| 04 Docker Logs and Exec | [new-style/04-docker-logs-and-exec/](new-style/04-docker-logs-and-exec/) | Read logs and exec into a container |
| 05 Docker Tag and Images | [new-style/05-docker-tag-and-images/](new-style/05-docker-tag-and-images/) | Tag images and inspect metadata |
| 06 Push to ECR | [new-style/06-push-to-ecr/](new-style/06-push-to-ecr/) | Login, tag, and push from EC2 to ECR |

## Getting Started

SSH to your Amazon Linux 2 EC2 instance, clone this repository, and open the first topic:

```bash
ssh -i your-key.pem ec2-user@<EC2_PUBLIC_IP>
git clone <REPO_URL> ~/ncc-training
cd ~/ncc-training/05-Docker/new-style/01-setup-docker-on-ec2
```

Follow [new-style/README.md](new-style/README.md) for the full topic order.

## Sample Application

This module uses a Python Flask web application to demonstrate Docker concepts. The app provides:

**Endpoints:**
- `/` - Main endpoint with container info
- `/health` - Health check
- `/info` - Detailed container information
- `/write` - Write data to demonstrate volumes
- `/read` - Read persisted data

**Location:** `application/` directory

You build this app on EC2 in every topic after setup. Compose, volumes, and networking beyond port publish are covered in later modules.

## Additional Resources

### Official Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Amazon ECR User Guide](https://docs.aws.amazon.com/ecr/)

### Quick References
- [QUICK_REFERENCE.md](./reference/QUICK_REFERENCE.md) - Common Docker commands
- [TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md) - Common issues and solutions

### Instructor Helper
- [new-style/helpers/run-ecr-lab.sh](new-style/helpers/run-ecr-lab.sh) - Installs Docker, builds the app, smoke-tests `/health`, and pushes to an ECR URI you pass in

### Next Steps After This Module
- **Docker Compose**: [06-Docker-Compose](../06-Docker-Compose/README.md)
- **CI/CD Integration**: Jenkins, GitHub Actions
- **Cloud runtimes**: AWS ECS (later in the course)

## Tips for Success

**Stay on EC2:**
- Build, run, and push from the instance, not from your laptop
- If `docker` asks for sudo, log out of SSH and log back in after `usermod -a -G docker ec2-user`

**Use Reference Materials:**
- Keep QUICK_REFERENCE.md open while practicing
- Consult TROUBLESHOOTING.md when stuck
- Use `docker <command> --help` for quick help

**Practice the build:**
- Every task after setup starts with `docker build`
- Rebuild after small Dockerfile edits so you see layer cache

## Getting Help

**During the Module:**
1. Check [TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md) first
2. Review [QUICK_REFERENCE.md](./reference/QUICK_REFERENCE.md)
3. Examine Docker logs: `docker logs <container>`
4. Consult instructor or peers
5. Search official Docker documentation

**Common Commands for Help:**
```bash
docker <command> --help
docker run --help
docker build --help
```

## Guided Learning Focus

Each topic is self-contained and designed to take about 20 minutes. Teach a few commands, then complete the Task before moving on.
