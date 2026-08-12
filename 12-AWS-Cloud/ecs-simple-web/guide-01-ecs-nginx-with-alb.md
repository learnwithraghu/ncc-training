# Guide 1: Launch nginx on ECS with an Application Load Balancer

## Goal

Deploy the official **nginx** Docker image on ECS Fargate from the AWS Console. Attach an **Application Load Balancer** so the site is reachable at a stable DNS name instead of a task public IP.

## Time

Approximately **35 minutes**.

## What You Need

- AWS Console in a region such as `us-east-1`
- A VPC with at least **two public subnets** in different Availability Zones (default VPC is fine)
- `ecsTaskExecutionRole` (create it in the task definition wizard if it is missing)

Access URL pattern for this lab:

```text
http://<ALB_DNS_NAME>
```

The ALB DNS name stays the same when ECS replaces tasks. That is the main reason to add a load balancer.

---

## Architecture (quick picture)

```text
Internet
   |
   v
Application Load Balancer  (port 80)
   |
   v
Target group  (IP targets, health check GET /)
   |
   v
ECS service on Fargate  (nginx container, port 80)
```

---

## Step 1: Create Cluster

ECS → **Clusters** → **Create cluster**.

- Cluster name: `nginx-demo-cluster`
- Infrastructure: **AWS Fargate (serverless)**
- **Create**

---

## Step 2: Security Groups

You need two security groups: one for the ALB and one for the ECS tasks.

### ALB security group

EC2 → **Security Groups** → **Create security group**.

- Name: `nginx-alb-sg`
- VPC: default VPC (or the VPC you will use)
- Inbound: HTTP **80** from **My IP** (or `0.0.0.0/0` for a classroom demo)
- Outbound: default

### ECS task security group

Create another security group.

- Name: `nginx-ecs-sg`
- VPC: same VPC as above
- Inbound: HTTP **80** from source **`nginx-alb-sg`** (select the ALB security group, not an IP range)
- Outbound: default (needed so the task can pull `nginx:latest` from Docker Hub)

Only the load balancer should reach the tasks on port 80.

---

## Step 3: Task Definition

ECS → **Task definitions** → **Create new task definition**.

**Task definition configuration**

- Task definition family: `nginx-demo`
- Launch type: **AWS Fargate**
- Operating system/Architecture: **Linux/X86_64**
- CPU: **0.25 vCPU**
- Memory: **0.5 GB**
- Task execution role: `ecsTaskExecutionRole` (create a new role if the dropdown is empty)

**Container**

- Container name: `nginx`
- Image URI: `nginx:latest`
- Essential: yes
- Port mappings: container port **80**, protocol **TCP**

Paste the image name exactly. This is a public Docker Hub image. Do not prefix it with an ECR registry. The execution role does not need ECR pull permissions for this guide.

**Logging**

- Use **Amazon CloudWatch Logs**
- Log group: `/ecs/nginx-demo`
- Create the log group if the wizard offers that option

**Volumes:** none.

**Create** the task definition.

---

## Step 4: Create the Service with a Load Balancer

Open cluster **`nginx-demo-cluster`** → **Services** → **Create**.

### Deployment configuration

- Compute options: **Launch type** → **Fargate**
- Application type: **Service**
- Task definition family: `nginx-demo` (latest revision)
- Service name: `nginx-demo-service`
- Desired tasks: **1**

### Networking

- VPC: default VPC (or your lab VPC)
- Subnets: select **at least two public subnets**
- Security group: **`nginx-ecs-sg`**
- **Public IP: Turned on** (needed so Fargate can pull `nginx:latest` from Docker Hub)

### Load balancing

- Load balancer type: **Application Load Balancer**
- Choose: **Create a new load balancer**
- Load balancer name: `nginx-demo-alb`
- Load balancer listener: HTTP port **80**
- Target group name: `nginx-demo-tg`
- Health check path: `/`
- Health check grace period: **60** seconds (gives nginx time to start on first deploy)

When the wizard asks for a load balancer security group, choose **`nginx-alb-sg`**.

If the wizard offers **Container to load balance**, pick container **`nginx`** on port **80**.

Review and **Create** the service.

Wait until:

- The service shows **1/1 tasks running**
- The target group shows the task as **healthy**

First deploy can take a few minutes while ECS creates the ALB, target group, and pulls the image.

---

## Step 5: Open the Website

1. EC2 → **Load Balancers** → open **`nginx-demo-alb`**
2. Copy **DNS name** (for example `nginx-demo-alb-1234567890.us-east-1.elb.amazonaws.com`)
3. Browser: `http://<ALB_DNS_NAME>`

You should see the nginx welcome page: **"Welcome to nginx!"**

If you get a timeout, confirm **`nginx-alb-sg`** allows HTTP from your IP and the target is **healthy**.

---

## Step 6: Confirm Load Balancer Routing (optional)

1. ECS → cluster **`nginx-demo-cluster`** → service **`nginx-demo-service`**
2. Open the **Tasks** tab and note the task ID
3. **Stop** the running task (ECS starts a replacement automatically)
4. Wait until the new task is **Running** and the target is **healthy** again
5. Refresh `http://<ALB_DNS_NAME>` — the site should still work

The ALB DNS name did not change. Only the task behind it changed.

---

## Troubleshooting

| Symptom | Check |
|---------|--------|
| Service fails to create ALB | At least two public subnets selected; unique ALB name in the region |
| Target **unhealthy** | Container port is **80**; health check path is **`/`**; **`nginx-ecs-sg`** allows port 80 from **`nginx-alb-sg`** |
| Cannot pull image | Public subnet + **Public IP turned on** on the service; outbound internet from the task |
| Browser timeout | **`nginx-alb-sg`** allows HTTP **80** from your IP; ALB is **active** |
| 502 Bad Gateway | Task not running yet; wait for health check grace period; check CloudWatch logs in `/ecs/nginx-demo` |
| Works on task IP but not ALB | You should use the ALB DNS name; verify target group registered the task private IP |

---

## Cleanup (when the lab is done)

Delete in this order to avoid dependency errors:

1. ECS → service **`nginx-demo-service`** → **Delete service** (check force delete if tasks remain)
2. EC2 → **Load Balancers** → delete **`nginx-demo-alb`**
3. EC2 → **Target Groups** → delete **`nginx-demo-tg`** (if it still exists)
4. ECS → cluster **`nginx-demo-cluster`** → **Delete cluster**
5. ECS → task definition **`nginx-demo`** → deregister revisions
6. EC2 → delete security groups **`nginx-alb-sg`** and **`nginx-ecs-sg`**
7. CloudWatch → delete log group **`/ecs/nginx-demo`** (optional)

---

## Checkpoint

1. What image URI is in the task definition, and why do you not need ECR for this lab?
2. Why does the ECS task security group allow port 80 from the ALB security group instead of from your IP?
3. What is the health check path, and what HTTP response does nginx return for it?
4. Why is the ALB DNS name more stable than a task public IP for users?

## Next Step

Compare with **[ECS Jenkins](../ecs-jenkins/guide-01-jenkins-ecs-public-image.md)** (direct task IP, no load balancer), or extend this lab by changing **Desired tasks** to **2** and watching the ALB spread traffic across both tasks.
