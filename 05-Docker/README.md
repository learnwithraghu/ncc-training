# Day 3, Part 1: Docker

This module covers containerization with Docker. You work entirely on an Amazon Linux 2023 EC2 instance. The sample is a single-page site for **Aether Launch**, a satellite launch company.

You build and serve that HTML from EC2, bake it into an image (with package installation in the Dockerfile), tag it with a naming convention, push to Amazon ECR, then pull and run it to validate.

This module stops after pull-and-run validation.

## What You Will Learn

By the end of this module, you will be able to:

- Install Docker on Amazon Linux 2023 EC2
- Build a static site image on EC2 and publish a port
- Write a Dockerfile that installs packages and copies HTML into an image
- Run, log, and exec into a container
- Name and tag images (`aether-launch:1.0`)
- Push from EC2 to Amazon ECR using the instance IAM role
- Pull that image back and run it to validate the push

## Time Estimate

Approximately **2.5 hours** total, split into 7 topics at about 20 minutes each.

## Prerequisites

- Completion of [Day 2](../00-course-roadmap.md#day-2-git-and-github-basics)
- An Amazon Linux 2023 EC2 instance you can SSH into as `ec2-user`
- An IAM instance profile on that EC2 instance that can push to and pull from ECR (no access keys)
- An ECR repository already created in `us-east-1`
- Security group: SSH (22). Port **8080** if you want to open the company page in a browser.

See [demo-infra-requirement.md](demo-infra-requirement.md) for the full checklist.

## Guided Learning Topics

Each topic folder in `new-style/` is independent. It includes `index.html`, `Dockerfile`, and `guide.md`. You do not reuse files from a previous folder.

| Topic | Folder | Focus |
|-------|--------|-------|
| 01 Setup Docker on EC2 | [new-style/01-setup-docker-on-ec2/](new-style/01-setup-docker-on-ec2/) | Install Docker on Amazon Linux 2023 |
| 02 Serve on EC2 | [new-style/02-serve-on-ec2/](new-style/02-serve-on-ec2/) | `docker build`, run, and serve the HTML on port 8080 |
| 03 Bake Image | [new-style/03-bake-image/](new-style/03-bake-image/) | Dockerfile, `apk add`, `COPY`, `docker build` |
| 04 Logs and Exec | [new-style/04-docker-logs-and-exec/](new-style/04-docker-logs-and-exec/) | Logs and exec |
| 05 Tag and Names | [new-style/05-docker-tag-and-images/](new-style/05-docker-tag-and-images/) | Naming and tagging convention |
| 06 Push to ECR | [new-style/06-push-to-ecr/](new-style/06-push-to-ecr/) | Push `aether-launch:1.0` to ECR |
| 07 Pull and Run | [new-style/07-pull-and-run/](new-style/07-pull-and-run/) | Pull from ECR and run to validate |

## Getting Started

```bash
ssh -i your-key.pem ec2-user@<EC2_PUBLIC_IP>
git clone <REPO_URL> ~/ncc-training
cd ~/ncc-training/05-Docker/new-style/01-setup-docker-on-ec2
```

Follow [new-style/README.md](new-style/README.md) for the full topic order.

## Sample Site

**Aether Launch** is a one-page satellite launch company site (`index.html`). Nginx serves it on container port 80, published as host port **8080**. Each topic folder in `new-style/` has its own copy.

## Additional Resources

### Official Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Amazon ECR User Guide](https://docs.aws.amazon.com/ecr/)

### Instructor Helper
- [new-style/helpers/run-ecr-lab.sh](new-style/helpers/run-ecr-lab.sh) - Builds and serves the HTML, bakes the image, curls **Aether Launch**, pushes to ECR, then pulls and runs again

### Next Steps After This Module
- **Docker Compose**: [06-Docker-Compose](../06-Docker-Compose/README.md)
- **CI/CD Integration**: Jenkins, GitHub Actions
- **Cloud runtimes**: AWS ECS (later in the course)

## Tips for Success

**Stay on EC2:**
- Serve, build, run, and push from the instance
- If `docker` asks for sudo, log out of SSH and log back in after `usermod -a -G docker ec2-user`

**Each folder stands alone:**
- `cd` into the topic folder you are teaching
- Use that folder's `index.html` and `Dockerfile`

## Getting Help

1. Open the topic `guide.md` in `new-style/`
2. Examine logs: `docker logs aether-web`
3. Consult instructor or peers

```bash
docker <command> --help
docker run --help
docker build --help
```

## Guided Learning Focus

Each topic is self-contained and designed to take about 20 minutes. Teach a few commands, then complete the Task before moving on.
