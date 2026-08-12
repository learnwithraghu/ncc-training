# Topic 6: Environment and Env Files

**Time:** 20 minutes

## Goal
Use environment variables to configure the app without changing source
code.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
vi .env.example
docker compose up -d
until curl -fsS http://localhost:5000/health; do sleep 1; done
curl http://localhost:5000/
docker compose down
```

## Guided Steps
1. Open `.env.example` and review the `web`-facing values (`ENVIRONMENT`,
   `APP_VERSION`, `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`,
   `DB_NAME`).
2. Start the stack using values from the file.
3. Verify `GET /` includes `environment` and `app_version` from the file.
4. Change `APP_VERSION` to something else, `docker compose up -d`
   again (no rebuild needed, only the container restarts), and confirm
   `GET /` reflects the new value.
5. Explain why env-based configuration helps reusable deployments -
   and, from Topic 2, why changing `DB_PASSWORD` here alone would *not*
   be enough to actually change the database's password.

## Checkpoint
Why is env-based configuration better than hardcoding values in code, and
why did we ask you to change `APP_VERSION` instead of a `DB_*` value in
this exercise?
