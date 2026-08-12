# Topic 1: Compose Mindset and Quick Checks

**Time:** 20 minutes

## Goal
Understand why Compose is useful and verify your environment.

## Commands to Use
```bash
docker compose version
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose config
```

## Guided Steps
1. Confirm Compose is installed.
2. Open the app folder used by this module.
3. Validate the Compose file (`docker-compose.yaml`).
4. Explain why a single file is easier than two long `docker run` commands
   (one for a Flask app, one for a MySQL database, wired together by
   hand).
5. Identify the two services defined for this module: `web` and `db`.

## Checkpoint
What does Compose simplify when an app needs a database alongside it?
