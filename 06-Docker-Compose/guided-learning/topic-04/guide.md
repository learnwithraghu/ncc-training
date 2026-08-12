# Topic 4: Build and Start Services

**Time:** 20 minutes

## Goal
Build the app image and start the full Compose stack (Flask + MySQL).

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose up -d --build
until curl -fsS http://localhost:5000/health; do sleep 1; done
docker compose ps
docker compose down
```

## Guided Steps
1. Build and start both services in detached mode.
2. Wait until the API health endpoint responds - it only reports
   `healthy` once it can reach MySQL.
3. Inspect service status with `docker compose ps`.
4. Identify which service exposes port 5000 and which exposes port 3306.
5. Tear down the stack.

## Checkpoint
Why does `GET /health` depend on MySQL being reachable, not just on the
Flask process being up?
