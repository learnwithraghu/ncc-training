# Topic 4: Build and Start Services

**Time:** 20 minutes

## Goal
Build images and start the full Compose stack.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose up -d --build
until curl -fsS http://localhost:5000/health; do sleep 1; done
docker compose ps
docker compose down
```

## Guided Steps
1. Build and start all services in detached mode.
2. Wait until the API health endpoint responds.
3. Inspect service status with `docker compose ps`.
4. Identify which service exposes port 5000.
5. Tear down the stack.

## Checkpoint
Why should you wait for health before running API tests?
