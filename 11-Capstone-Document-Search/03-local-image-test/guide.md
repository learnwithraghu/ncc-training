# Step 03: Build and Test the Docker Image Locally

## Goal
Build the Streamlit image on your laptop and prove the container works before AWS.

## Time
Approximately **20 minutes**.

## What You Brought Forward

```text
03-local-image-test/
├── guide.md
├── requirements.txt
├── app/app.py
├── sample-documents/
├── Dockerfile
├── .dockerignore
└── docker-compose.yml
```

```bash
cp ../02-dockerize/.env ./.env
# or: cp ../.env_example .env
```

If `.env` is missing, `docker build` fails on `COPY .env .env`.

---

## Step 1: Build

```bash
cd 11-Capstone-Document-Search/03-local-image-test
docker build --platform linux/amd64 -t document-search:latest .
```

## Step 2: Run

```bash
docker run -d -p 8501:8501 --name doc-search-local document-search:latest
```

Secrets are already baked in — no `--env-file` required for this lab.

## Step 3: Verify

```bash
curl -f http://localhost:8501/_stcore/health
```

Open a browser: `http://localhost:8501`

Upload a PDF from `sample-documents/`, click **Process Document**, confirm the table appears, and download Excel.

## Step 4: Clean Up Container

```bash
docker stop doc-search-local
docker rm doc-search-local
```

Keep the image `document-search:latest` for ECR.

## Optional: Compose

```bash
docker compose up -d --build
curl -f http://localhost:8501/_stcore/health
docker compose down
```

---

## Checkpoint

1. Which URL proves Streamlit is healthy?
2. Why rebuild after editing `.env`?
3. What local tag will you push to ECR next?

## Next Step

Go to **[04-ecr-push](../04-ecr-push/)**.
