# Step 05: Deploy to Amazon ECS (AWS Console)

## Goal
Deploy the image from ECR to Amazon ECS Fargate using the AWS Management Console, then open the app on the task public IP.

## Time
Approximately **30 minutes**.

## What You Brought Forward

```text
05-ecs-deploy/
├── guide.md
├── app.py
├── requirements.txt
├── .env_example
├── .gitignore
├── Dockerfile
├── .dockerignore
└── docker-compose.yml
```

You should already have:

- Image in ECR from Step 04
- Image URI like:
  `<ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/document-search:latest`
- Local `.env` values (baked into that image)

Bring `.env` only if you need to rebuild/re-push:

```bash
cp ../04-ecr-push/.env ./.env
```

---

## Tutor Talk: Local vs Console

| Work | Where |
|------|--------|
| Build image | Your laptop |
| Push image | Your laptop → ECR |
| Create cluster / task / service | **AWS Console (UI)** |
| Open the running app | Browser → task public IP |

This lab intentionally uses a **public IP on the Fargate task**. No Application Load Balancer.

Caveat your tutor will repeat:

- The public IP is **temporary**
- If the task is replaced, the IP can change
- Prefer security-group access from **My IP** on port `5000`

Because secrets were **baked into the image** in Step 02, you do **not** need to re-enter `LLM_API_KEY` in the task definition for the app to start. Keep using the execution role for ECR pulls; do not paste AWS access keys into the container environment for pulling images.

---

## Step 1: Create an ECS Cluster (Console)

1. AWS Console → **Elastic Container Service**
2. **Clusters** → **Create cluster**
3. Name: `document-search-cluster`
4. Infrastructure: **AWS Fargate (serverless)**
5. Create and wait until Active

## Step 2: Create a Security Group (Console)

1. **EC2** → **Security Groups** → **Create security group**
2. Name: `document-search-sg`
3. VPC: default VPC (or your lab VPC)
4. Inbound rule:
   - Type: Custom TCP
   - Port: `5000`
   - Source: **My IP** (preferred)
5. Create

## Step 3: Create a Task Definition (Console)

1. ECS → **Task definitions** → **Create new task definition**
2. Family: `document-search`
3. Launch type: **Fargate**
4. OS/Architecture: **Linux / X86_64**
5. CPU: `0.25 vCPU` · Memory: `0.5 GB`
6. Task execution role: `ecsTaskExecutionRole` (create with defaults if needed)
7. Add container:
   - Name: `document-search`
   - Image URI: your ECR URI ending in `document-search:latest`
   - Port: `5000` TCP
8. Create

Optional env vars for clarity (not required if baked):

- `APP_ENV=ecs`

Do **not** add `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` just to pull from ECR. The execution role handles that.

## Step 4: Create the Service (Console)

1. Open `document-search-cluster` → **Services** → **Create**
2. Launch type: Fargate
3. Task definition: `document-search` (latest)
4. Service name: `document-search-service`
5. Desired tasks: `1`
6. Networking:
   - Public subnet(s)
   - Security group: `document-search-sg`
   - **Public IP: Turned on**
7. Load balancing: **None**
8. Create and wait for a **Running** task

## Step 5: Find the Public IP and Test

1. Service → **Tasks** → open the running task
2. Copy **Public IP**
3. Test:

```bash
curl http://<TASK_PUBLIC_IP>:5000/
curl http://<TASK_PUBLIC_IP>:5000/health
```

Or open `http://<TASK_PUBLIC_IP>:5000/` in a browser.

## Step 6: Check Logs If Needed

In the task view, open **Logs** (CloudWatch). Look for Flask startup output or Python tracebacks.

---

## Troubleshooting

| Symptom | Likely cause |
|---------|----------------|
| Cannot pull image | Wrong image URI, or execution role missing ECR permissions |
| Task never gets a public IP | Public IP disabled, or private-only subnet |
| Connection timed out | Security group missing port 5000 from your IP |
| App unhealthy / crash loop | Rebuild/push after fixing app or `.env`, then force new deployment |

---

## Checkpoint

1. Which steps are Console-only in this capstone?
2. Why can the URL change after a redeploy?
3. Why might you still avoid putting AWS access keys into the task env even though `.env` was baked for LLM settings?

## Next Step

Go to **[06-final-demo](../06-final-demo/)** — present the full path from local build to ECS access.
