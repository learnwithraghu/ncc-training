# Step 06: Final Demo

## Goal
Present the full tutor path: application → Dockerize (with baked secrets) → local test → ECR → ECS Console → public-IP access.

## Time
Approximately **20 minutes**.

## What You Brought Forward

This folder has the complete lab tree used through the course:

```text
06-final-demo/
├── guide.md
├── app.py
├── requirements.txt
├── Dockerfile
├── .dockerignore
└── docker-compose.yml
```

Shared template for secrets: `../.env_example` at the module root. Optional: keep a local `.env` for rebuild demos only. Do not show secret values on screen.

---

## Demo Story (Say This)

1. **Application** — We started with a small Flask API and one module-root `.env_example` template.
2. **Dockerize** — We wrote a Dockerfile and, for this class, baked `.env` into the image. We did not use Secrets Manager.
3. **Local test** — We built `document-search:latest` and curled `/health` on localhost.
4. **ECR** — We created a repository and pushed the image from the laptop.
5. **ECS** — We deployed with the AWS Console on Fargate and opened the **task public IP**.

---

## Live Checklist

### On your laptop

- [ ] Show folder progression `01` → `06`
- [ ] Show module-root `.env_example` (not real secrets)
- [ ] Show `Dockerfile` line `COPY .env .env` and explain the classroom trade-off
- [ ] Show `docker images | grep document-search`
- [ ] Optional quick local proof:

```bash
docker run --rm -d -p 5000:5000 --name demo-local document-search:latest
curl http://localhost:5000/health
docker stop demo-local
```

### In the AWS Console

- [ ] ECR repository `document-search` with tag `latest`
- [ ] ECS cluster `document-search-cluster`
- [ ] Service `document-search-service` with a Running task
- [ ] Copy task **Public IP**
- [ ] Browser or curl:

```bash
curl http://<TASK_PUBLIC_IP>:5000/
curl http://<TASK_PUBLIC_IP>:5000/health
```

---

## Talking Points for Production (Keep Short)

- Baking secrets is fine for disposable lab keys only
- Production would use runtime secrets (Secrets Manager / SSM) and never bake keys into layers
- A stable public URL would use an Application Load Balancer — out of scope here
- Prefer IAM roles over long-lived access keys on servers

## Cleanup

- Set ECS desired count to `0` or delete the service
- Delete unused ECR images if your instructor asks
- Rotate any keys that were baked into a shared image

## Congratulations

You finished the Document Search Capstone: local Docker build, ECR push, and ECS Fargate access via the task public IP.
