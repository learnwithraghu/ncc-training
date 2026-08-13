# Docker New Style — Aether Launch on EC2 to ECR

Work through these topics in order on an Amazon Linux 2023 EC2 instance. Each topic folder is independent: it has its own `index.html`, `Dockerfile`, and `guide.md`. You do not need files from a previous folder.

The site is a single-page company page for **Aether Launch**, a satellite launch company.

## Recommended Flow

1. Open the topic folder.
2. Walk through the commands on EC2.
3. Complete the **Task**.
4. Answer the checkpoint before moving on.

## Topic List

| Folder | Focus |
|--------|-------|
| [01-setup-docker-on-ec2/](01-setup-docker-on-ec2/) | Install Docker on Amazon Linux 2023 |
| [02-serve-on-ec2/](02-serve-on-ec2/) | `docker build`, run, and serve the HTML on port 8080 |
| [03-bake-image/](03-bake-image/) | Dockerfile, package install, `COPY`, `docker build` |
| [04-docker-logs-and-exec/](04-docker-logs-and-exec/) | Logs and exec on the baked image |
| [05-docker-tag-and-images/](05-docker-tag-and-images/) | Naming and tagging convention |
| [06-push-to-ecr/](06-push-to-ecr/) | Push `aether-launch:1.0` from EC2 to ECR |
| [07-pull-and-run/](07-pull-and-run/) | Pull from ECR and run to validate |

## How each folder is laid out

```text
index.html      Aether Launch company page
Dockerfile      nginx + COPY index.html (topic 02 is two lines; later topics add apk add and a health check)
.dockerignore   keeps guide.md out of the build
guide.md        commands, steps, task, checkpoint
```

## Instructor Helper

```bash
cd ~/ncc-training/05-Docker/new-style/helpers
bash run-ecr-lab.sh
```

The script asks only for the ECR image URI. It uses the EC2 IAM role, builds and serves the HTML, bakes the image, curls **Aether Launch**, pushes, then pulls and runs again.

## Scope Boundary

We stop after pull-and-run validation. Do not continue into ECS, Compose, or Kubernetes in this module.
