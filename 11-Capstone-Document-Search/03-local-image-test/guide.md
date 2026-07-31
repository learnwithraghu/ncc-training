# Step 03: Build and Test the Docker Image Locally

## Goal
Build the image on your laptop and prove the container works before you touch AWS.

## Time
Approximately **20 minutes**.

## What You Brought Forward

```text
03-local-image-test/
├── guide.md
├── app.py
├── requirements.txt
├── Dockerfile
├── .dockerignore
└── docker-compose.yml   ← optional helper
```

Bring your secrets file forward (template lives only at `../.env_example`):

```bash
cp ../02-dockerize/.env ./.env
# or: cp ../.env_example .env   # then edit values
```

If `.env` is missing, the Docker build will fail on `COPY .env .env`. That is intentional in this lab.

---

## Tutor Talk: Why Test Locally First?

A common student mistake is pushing a broken image to ECR, then debugging only on ECS. Your tutor wants the opposite loop:

```text
build locally → curl locally → only then push to ECR
```

If `/health` fails on localhost, it will also fail in ECS — and ECS failures are slower to diagnose.

---

## Step 1: Confirm Prerequisites

```bash
cd 11-Capstone-Document-Search/03-local-image-test
docker --version
ls -la .env Dockerfile app.py
```

## Step 2: Build the Image

```bash
docker build --platform linux/amd64 -t document-search:latest .
```

What should happen:

- Base image is pulled (first time only)
- `pip install` runs
- `app.py` and `.env` are copied
- Build finishes with a success message

If you see `COPY failed: file not found .env`, run `cp ../.env_example .env`, fill in values, and rebuild.

## Step 3: Run a Container

```bash
docker run -d -p 5000:5000 --name doc-search-local document-search:latest
```

Because `.env` was baked into the image, you do **not** need `--env-file` for this lab run. The app loads `/app/.env` inside the container.

## Step 4: Test the Endpoints

```bash
curl http://localhost:5000/
curl http://localhost:5000/health
```

Expected ideas:

- `/` returns JSON with `"message": "Document Search API is running"`
- `/` shows your `llm_model` value from `.env` (not `not-set`)
- `/health` returns `{"status":"healthy"}`

Also inspect logs if something looks wrong:

```bash
docker logs doc-search-local
```

## Step 5: Clean Up the Test Container

```bash
docker stop doc-search-local
docker rm doc-search-local
```

Keep the **image** (`document-search:latest`). You need it for the ECR push step.

## Optional: Docker Compose

Compose is only a convenience wrapper around the same image:

```bash
docker compose up -d --build
curl http://localhost:5000/health
docker compose down
```

Secrets are already inside the image from the bake step, so Compose does not need an `env_file` entry for this lab.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `COPY .env` fails | Create `.env` in this folder |
| Port 5000 already in use | Stop the other process or use `-p 5001:5000` |
| `exec format error` later on ECS | Rebuild with `--platform linux/amd64` |
| `llm_model` is `not-set` | Rebuild after fixing `.env` — old layers may still have an empty/old file |

Remember: after changing `.env`, you must **rebuild** the image because secrets were baked at build time.

---

## Checkpoint

1. Which command proves the container is healthy?
2. Why must you rebuild after editing `.env` in this lab design?
3. What local image tag will you push to ECR next?

## Next Step

Go to **[04-ecr-push](../04-ecr-push/)** — same code and Dockerfile, plus ECR overview and push commands.
