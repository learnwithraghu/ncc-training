# Day 3, Guide 7: Docker Compose Basics

## Goal
Understand the Docker Compose file format and run a simple multi-container application.

## Time
Approximately **60 minutes**.

## Prerequisites

- Docker Compose installed (`docker compose version`)
- Completion of [05-Docker](../05-Docker/README.md)

---

## 1. Why Docker Compose?

Most real applications need more than one container:

- Web application + database
- API + cache + message queue

Docker Compose lets you define and run multiple containers with a single YAML file.

## 2. Compose File Structure

A basic `docker-compose.yml`:

```yaml
version: "3.9"

services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html

  db:
    image: postgres:15
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydb
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
```

## 3. Common Commands

```bash
# Start all services in the background
docker compose up -d

# View logs
docker compose logs

# Stop all services
docker compose down

# Stop and remove volumes
docker compose down -v

# Scale a service
docker compose up -d --scale web=3
```

## 4. Build from Dockerfile

You can build an image directly from a Dockerfile in Compose:

```yaml
services:
  app:
    build: .
    ports:
      - "5000:5000"
```

---

## Hands-On: Run Nginx with Compose

### Step 1: Open the module app

```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
```

### Step 2: Review the Compose file

```bash
vi docker-compose.yml
```

### Step 3: Validate the Compose config

Run:

```bash
docker compose config
```

### Step 4: Start the service

```bash
docker compose up -d
until curl -fsS http://localhost:5000/health; do sleep 1; done
```

### Step 5: Verify

```bash
curl http://localhost:5000/health
curl http://localhost:5000/
docker compose ps
docker compose logs
```

### Step 6: Clean up

```bash
docker compose down
```

---

## Check Your Understanding

1. What problem does Docker Compose solve?
2. What is the difference between `docker compose up` and `docker compose up -d`?
3. How do you remove containers and volumes together?
4. How do you expose a container port to the host?

---

## Next Step

Continue to [guide_02_multi_service_lab.md](guide_02_multi_service_lab.md) to build a Flask + Redis application with Compose.
