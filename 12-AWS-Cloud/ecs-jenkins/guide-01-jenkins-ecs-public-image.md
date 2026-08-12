# Guide 1: Launch Jenkins on ECS with a Public Docker Image

## Goal
Deploy Jenkins on ECS Fargate from the AWS Console using the public Docker Hub image in the task definition. Open the Jenkins UI on the task public IP.

## Time
Approximately **30 minutes**.

## What You Need

- AWS Console in a region such as `us-east-1`
- A VPC with at least one public subnet (default VPC is fine)
- `ecsTaskExecutionRole` (create it in the task definition wizard if it is missing)

Access URL pattern for this lab:

```text
http://<TASK_PUBLIC_IP>:8080
```

The public IP is temporary and can change when the task is replaced. Prefer security-group access from **My IP** on port **8080**.

This lab uses **ephemeral storage**. Jenkins writes `/var/jenkins_home` on the task disk. Jobs, plugins, and the admin password are lost if the task is stopped or replaced. Do not add EFS in this lab.

This is not the [07-Jenkins](../../07-Jenkins/README.md) CI path. There is no bind mount and no Docker socket. The task definition only runs the Jenkins UI container.

---

## Step 1: Create Cluster

ECS → Clusters → Create cluster.

- Cluster name: `jenkins-cluster`
- Infrastructure: **AWS Fargate (serverless)**
- Create

## Step 2: Security Group

EC2 → Security Groups → Create security group.

- Name: `jenkins-ecs-sg`
- VPC: default VPC (or the VPC you will use for the service)
- Inbound: Custom TCP **8080** from **My IP**
- Outbound: default (needed so the task can pull `jenkins/jenkins:lts-jdk17` and download plugins)

Port **50000** is for inbound Jenkins agents. Skip it in this lab.

## Step 3: Task Definition

ECS → Task definitions → Create new task definition.

- Family: `jenkins`
- Launch type: **AWS Fargate**
- Operating system/Architecture: **Linux/X86_64**
- CPU: **1 vCPU**
- Memory: **2 GB** (Jenkins needs more than a small web app)
- Task execution role: `ecsTaskExecutionRole` (create a new role if the dropdown is empty)

Container:

- Name: `jenkins`
- Image URI: `jenkins/jenkins:lts-jdk17`
- Essential: yes
- Port mappings: container port **8080**, protocol TCP

Paste the image name exactly. This is a public Docker Hub image. Do not prefix it with an ECR registry. The execution role does not need ECR pull permissions for this guide.

Logging:

- Use CloudWatch Logs
- Log group: `/ecs/jenkins`
- Create the log group if the wizard offers that option

Volumes: none. Do not attach EFS.

Create the task definition.

## Step 4: Service

Open cluster `jenkins-cluster` → Services → Create.

- Compute: **Fargate**
- Task definition family: `jenkins` (latest revision)
- Service name: `jenkins-service`
- Desired tasks: **1**
- Networking: public subnet(s), security group `jenkins-ecs-sg`
- **Public IP: Turned on**
- Load balancing: None

Create the service and wait until the task is **Running**.

## Step 5: Access and Unlock Jenkins

1. Open the running task → copy **Public IP**
2. Browser: `http://<TASK_PUBLIC_IP>:8080`
3. Jenkins asks for an initial admin password. There is no SSH and no `docker exec` on Fargate.
4. Open CloudWatch → Log groups → `/ecs/jenkins` → the task log stream
5. Find the line that says Jenkins generated an admin password, copy the password, and paste it into the unlock screen
6. Install suggested plugins, create an admin user, accept the Jenkins URL, and start using Jenkins

If the log stream is empty, wait a minute. First boot pulls the image and starts Jenkins before it prints the password.

---

## Troubleshooting

| Symptom | Check |
|---------|--------|
| Cannot pull image | Public subnet + public IP on; outbound internet; image is exactly `jenkins/jenkins:lts-jdk17` |
| Timeout in browser | SG port 8080 from **My IP**; public IP enabled; task is Running |
| Unlock screen, no password | CloudWatch log group `/ecs/jenkins`; wait for first-boot logs |
| Task stops / OOM | Increase task memory (try 4 GB) |
| Jenkins empty after refresh | Ephemeral disk; a new task is a fresh Jenkins |

## Checkpoint

1. Which port must the security group allow?
2. Where does the task definition get the Jenkins image in this guide?
3. Why can the URL change after the task is replaced?
4. What happens to Jenkins jobs if the Fargate task is stopped?

## Next Step

Go to **[guide-02-jenkins-ecs-ecr-pull-through.md](./guide-02-jenkins-ecs-ecr-pull-through.md)**.
