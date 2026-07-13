# Topic 11: Rebuild and Rollout Workflow

**Time:** 20 minutes

## Goal
Practice iterative edit-build-run workflow with Compose.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
vi app.py
docker compose up -d --build
until curl -fsS http://localhost:5000/health; do sleep 1; done
curl http://localhost:5000/
docker compose down
```

## Guided Steps
1. Open `app.py` and change a response field.
2. Rebuild and restart services.
3. Verify the updated response from `/`.
4. Discuss when `--build` is required.
5. Explain a safe local rollout loop.

## Checkpoint
When does Compose reuse cached images and when should you force a rebuild?
