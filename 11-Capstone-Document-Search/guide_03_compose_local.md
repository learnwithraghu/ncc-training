# Day 5, Capstone Guide 3: Run Locally with Docker Compose

## Goal
Run the document-search application locally using Docker Compose.

## Time
Approximately **15 minutes**.

---

## Step 1: Create docker-compose.yml

```bash
cd ~/ncc-labs/day5/document-search
```

Create the file:

```yaml
version: "3.9"

services:
  doc-search:
    build: .
    ports:
      - "5000:5000"
    environment:
      - APP_ENV=local
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

## Step 2: Start the Application

```bash
docker compose up -d
```

## Step 3: Verify

```bash
curl http://localhost:5000/
curl http://localhost:5000/health
docker compose ps
docker compose logs
```

## Step 4: Clean Up

```bash
docker compose down
```

---

## Check Your Understanding

1. What does `build: .` mean in the Compose file?
2. How does the healthcheck work?
3. Why is `restart: unless-stopped` useful?
