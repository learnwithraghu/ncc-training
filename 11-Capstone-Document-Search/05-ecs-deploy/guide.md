# Step 05: Deploy to Amazon ECS (AWS Console)

## Goal
Deploy the ECR image to ECS Fargate from the AWS Console and open the Streamlit UI on the task public IP.

## Time
Approximately **30 minutes**.

## What You Brought Forward

Same app tree as previous steps, plus an image already in ECR:

```text
<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/document-search:latest
```

Access URL pattern for this lab:

```text
http://<task-public-ip>:8501
```

The public IP is temporary and can change when the task is replaced. Prefer security-group access from **My IP** on port **8501**.

Because `.env` (including `LLM_*`) was baked into the image, you do not need Secrets Manager or Bedrock. Do not paste AWS access keys into the task only to pull from ECR — use the **task execution role**.

---

## Step 1: Create Cluster

ECS → Clusters → Create → name `document-search-cluster` → Fargate → Create.

## Step 2: Security Group

EC2 → Security Groups → Create `document-search-sg`

- Inbound: Custom TCP **8501** from My IP
- Outbound: default (needed so the task can call your LLM endpoint)

## Step 2.5: Copy the Exact ECR URI from Console

Open AWS Console → ECR → Repositories → `document-search`.

Copy the full image URI for `:latest` and keep it ready for Task Definition.

Do not manually type the URI. Paste the exact Console value.

## Step 3: Task Definition

- Family: `document-search`
- Fargate · Linux/X86_64
- CPU `0.5 vCPU` · Memory `1 GB` (Streamlit + PDF processing needs adequate memory)
- Execution role: `ecsTaskExecutionRole`
- Container image: paste the exact ECR image URI copied from Console (`us-east-1`)
- Port: **8501**

## Step 4: Service

- Cluster: `document-search-cluster`
- Service name: `document-search-service`
- Desired tasks: `1`
- Public subnet(s), security group `document-search-sg`
- **Public IP: Turned on**
- Load balancing: None

## Step 5: Access

1. Open the running task → copy **Public IP**
2. Browser: `http://<TASK_PUBLIC_IP>:8501`
3. Upload a sample PDF, process, download Excel
4. Optional health check:

```bash
curl -f http://<TASK_PUBLIC_IP>:8501/_stcore/health
```

---

## Troubleshooting

| Symptom | Check |
|---------|--------|
| Cannot pull image | URI must be the exact Console copy in `us-east-1`; execution role must allow ECR pull |
| Timeout in browser | SG port 8501, public IP enabled |
| LLM errors in UI | Baked `LLM_*` values; outbound internet from task |
| OOM / task stop | Increase task memory |

## Checkpoint

1. Which port must the security group allow?
2. Why can the URL change after redeploy?
3. Where do Excel results go after processing on ECS?
4. Why should you paste the ECR URI from Console instead of manually constructing it?

## Next Step

Go to **[06-eks-deploy](../06-eks-deploy/)**.
