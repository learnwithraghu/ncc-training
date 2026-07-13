# Topic 5: Health Checks and Dependencies

**Time:** 20 minutes

## Goal
Understand how service dependencies and health checks affect startup order.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
vi docker-compose.yml
docker compose up -d
docker compose ps
docker compose down
```

## Guided Steps
1. Review `depends_on` with health conditions.
2. Review health checks for `redis` and `web`.
3. Start the stack.
4. Watch service state transitions in `docker compose ps`.
5. Explain how dependency checks reduce startup race failures.

## Checkpoint
What can go wrong if `web` starts before `redis` is ready?
