# Topic 6: Environment and Env Files

**Time:** 20 minutes

## Goal
Use environment variables to configure services without changing source code.

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
1. Open `.env.example` and review key values.
2. Start the stack using env values from the file.
3. Verify the API response includes expected environment fields.
4. Change one value, restart, and verify the change.
5. Explain why env files help reusable deployments.

## Checkpoint
Why is env-based configuration better than hardcoding values in code?
