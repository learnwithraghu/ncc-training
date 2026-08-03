# Step 06: Final Demo

## Goal
Present the full path: License Renewal Streamlit app → Dockerize (baked `.env`) → local test → ECR → ECS Console → public-IP UI with PDF upload and Excel download.

## Time
Approximately **20 minutes**.

## Demo Story

1. **Application** — Streamlit License Renewal processor; LLM HTTP endpoint; upload in browser; no Bedrock; no S3.
2. **Dockerize** — Dockerfile bakes `.env` (classroom only).
3. **Local test** — `document-search:latest` on port 8501.
4. **ECR** — image pushed from the laptop.
5. **ECS** — Fargate task; open `http://<public-ip>:8501`.

## Live Checklist

### Laptop

- [ ] Show module-root `.env_example` (hide real secrets)
- [ ] Show `app/app.py` LLM call path (no boto3)
- [ ] Show `Dockerfile` `COPY .env .env`
- [ ] `docker images | grep document-search`
- [ ] Optional: open local `http://localhost:8501`

### AWS Console

- [ ] ECR image `document-search:latest`
- [ ] ECR URI copied from Console (`us-east-1`) and used in ECS task definition
- [ ] ECS service running
- [ ] Browser to task public IP on **8501**
- [ ] Upload sample PDF → Process → Download Excel

```bash
curl -f http://<TASK_PUBLIC_IP>:8501/_stcore/health
```

## Cleanup

- Scale ECS desired count to 0 or delete the service
- Delete unused ECR images if asked
- Rotate keys that were baked into shared images

## Congratulations

You finished the Document Search Capstone with a real Streamlit document processor, local Docker build, ECR push, and ECS Fargate access.
