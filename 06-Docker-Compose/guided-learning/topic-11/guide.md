# Topic 11: Rebuild and Rollout Workflow

**Time:** 20 minutes

## Goal
Practice the iterative edit-build-run workflow with Compose.

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
1. Open `app.py` and change the `message` field returned by `GET /`.
2. Rebuild and restart services with `docker compose up -d --build`.
3. Verify the updated response from `GET /`.
4. Discuss when `--build` is required (code changes) versus when a plain
   `docker compose up -d` restart is enough (env/config changes, as in
   Topic 6).
5. Explain a safe local rollout loop, and why `db` doesn't need rebuilding
   for this kind of change - only `web` has a `Dockerfile`.

## Checkpoint
When does Compose reuse cached image layers and when should you force a
rebuild?
