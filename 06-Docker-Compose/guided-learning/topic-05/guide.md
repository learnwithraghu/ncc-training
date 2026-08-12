# Topic 5: Health Checks and Dependencies

**Time:** 20 minutes

## Goal
Understand how service dependencies and health checks affect startup order.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
vi docker-compose.yaml
docker compose up -d
docker compose ps
docker compose down
```

## Guided Steps
1. Review `web`'s `depends_on: db: condition: service_healthy`.
2. Review the healthcheck for `db` (`mysqladmin ping`) and for `web`
   (a Python request to `/health`).
3. Start the stack.
4. Watch service state transitions in `docker compose ps` - `db` has to
   report `healthy` before `web` is even started.
5. Explain how `condition: service_healthy` reduces startup race
   failures compared to `depends_on` with no condition (which only waits
   for the container to *start*, not for MySQL to actually accept
   connections).

## Checkpoint
What can go wrong if `web` starts before MySQL is ready to accept
connections?
