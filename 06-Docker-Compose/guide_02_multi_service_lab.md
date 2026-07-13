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

You will run a Docker Compose app with:

- a Flask API (`web`)
- a background worker (`worker`)
- a Redis service (`redis`)

The API queues events in Redis and the worker processes them into a shared data volume.

## Project Structure

```
/workspaces/ncc-training/06-Docker-Compose/application/
├── app.py
├── worker.py
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
└── .env.example
```

## Step 1: Open the App Directory

```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
vi docker-compose.yml
```

## Step 2: Review App Components

```bash
vi app.py
vi worker.py
vi Dockerfile
```

Confirm:

- `web` exposes `/`, `/health`, `/events`, and `/processed`
- `worker` processes queued events
- Redis acts as the queue backend

## Step 3: Build and Run

```bash
docker compose up -d --build
until curl -fsS http://localhost:5000/health; do sleep 1; done
```

## Step 4: Test

```bash
curl http://localhost:5000/
curl http://localhost:5000/health
curl -X POST http://localhost:5000/events -H 'Content-Type: application/json' -d '{"title":"compose-lab"}'
curl http://localhost:5000/events
curl http://localhost:5000/processed
```

You should see a healthy app, an event queued, and processed output once the worker consumes it.

## Step 5: Inspect and Scale

```bash
docker compose ps
docker compose logs web
docker compose logs worker
docker compose logs redis
docker compose up -d --scale worker=2
```

## Step 6: Clean Up

```bash
docker compose down
```

---

## Day 3 Completion Checklist

By the end of this guide, you should have:

- [ ] A Docker image for the module app
- [ ] A `docker-compose.yml` running web + worker + redis
- [ ] A working multi-service app on `localhost:5000`

On **Day 4**, you will automate the Docker build and push to ECR using Jenkins and GitHub Actions.

---

## Check Your Understanding

1. What does `depends_on` do in a Compose file?
2. Why is Redis a good fit for queue-based workflows?
3. What does `restart: unless-stopped` mean?
4. How would you scale the `worker` service to 3 instances?
