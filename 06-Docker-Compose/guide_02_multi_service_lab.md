# Day 3, Guide 8: Multi-Service Lab with Flask and Redis

## Goal
Build a real multi-service application using Docker Compose.

## Time
Approximately **60 minutes**.

## Prerequisites

- Completion of [guide_01_compose_basics.md](guide_01_compose_basics.md)
- Working directory: `~/ncc-labs/day3/`

---

## The Application

You will build a simple Flask web app that counts page visits using Redis as a cache.

## Project Structure

```
~/ncc-labs/day3/flask-redis/
├── app.py
├── requirements.txt
├── Dockerfile
└── docker-compose.yml
```

## Step 1: Create the Flask App

```bash
mkdir -p ~/ncc-labs/day3/flask-redis
cd ~/ncc-labs/day3/flask-redis
```

Create `app.py`:

```python
from flask import Flask
import redis
import os

app = Flask(__name__)
cache = redis.Redis(host=os.environ.get("REDIS_HOST", "redis"), port=6379)

@app.route("/")
def hello():
    count = cache.incr("hits")
    return f"Hello! This page has been visited {count} times.\n"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

Create `requirements.txt`:

```
flask==3.0.0
redis==5.0.1
```

## Step 2: Create the Dockerfile

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
```

## Step 3: Create docker-compose.yml

```yaml
version: "3.9"

services:
  web:
    build: .
    ports:
      - "5000:5000"
    environment:
      - REDIS_HOST=redis
    depends_on:
      - redis
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5000/"]
      interval: 30s
      timeout: 10s
      retries: 3

  redis:
    image: redis:7-alpine
    restart: unless-stopped
```

## Step 4: Build and Run

```bash
docker compose up -d --build
```

## Step 5: Test

```bash
curl http://localhost:5000
curl http://localhost:5000
curl http://localhost:5000
```

Each request should increment the visit counter.

## Step 6: Inspect and Scale

```bash
docker compose ps
docker compose logs web
docker compose logs redis
```

## Step 7: Clean Up

```bash
docker compose down
```

---

## Day 3 Completion Checklist

By the end of this guide, you should have:

- [ ] A Docker image for a Python Flask app
- [ ] A `docker-compose.yml` running Flask + Redis
- [ ] A working multi-service app on `localhost:5000`

On **Day 4**, you will automate the Docker build and push to ECR using Jenkins and GitHub Actions.

---

## Check Your Understanding

1. What does `depends_on` do in a Compose file?
2. Why is Redis a good fit for a visit counter?
3. What does `restart: unless-stopped` mean?
4. How would you scale the `web` service to 3 instances?
