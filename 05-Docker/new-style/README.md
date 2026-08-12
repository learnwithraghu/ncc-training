# Docker New Style — EC2 Build to ECR

Work through these topics in order on an Amazon Linux 2 EC2 instance. Each topic teaches a few commands, then gives you a task to try on your own.

This track stops after you push an image to Amazon ECR. Compose, volumes, and ECS deploy are later modules.

## Recommended Flow

1. Open the topic guide.
2. Walk through the commands on EC2.
3. Complete the **Task** without looking at the guided steps.
4. Answer the checkpoint before moving on.
5. Finish each topic in about 20 minutes.

## Topic List

| Folder | Focus |
|--------|-------|
| [01-setup-docker-on-ec2/](01-setup-docker-on-ec2/) | SSH to Amazon Linux 2, install Docker, run `hello-world` |
| [02-docker-build/](02-docker-build/) | Read the Dockerfile and master `docker build` |
| [03-docker-run-and-ports/](03-docker-run-and-ports/) | Run the image and publish ports |
| [04-docker-logs-and-exec/](04-docker-logs-and-exec/) | Read logs and exec into a container |
| [05-docker-tag-and-images/](05-docker-tag-and-images/) | Tag images and inspect what you built |
| [06-push-to-ecr/](06-push-to-ecr/) | Login, tag, and push from EC2 to ECR |

## Lab Setup on EC2

Clone this repository on the instance, then work from the sample app:

```bash
cd ~/ncc-training/05-Docker/application
```

Adjust the path if you cloned the repo somewhere else.

## Instructor Helper

Before teaching, run the full lab on a fresh Amazon Linux 2 EC2 instance:

```bash
cd ~/ncc-training/05-Docker/new-style/helpers
bash run-ecr-lab.sh
```

The script asks only for the ECR image URI. Region is us-east-1. It uses the EC2 IAM role already attached to the instance (not access keys), installs Docker, builds the sample app, smoke-tests `/health`, and pushes to ECR.

## Scope Boundary

We stop after ECR push. Do not continue into ECS, Compose, or Kubernetes in this module.
