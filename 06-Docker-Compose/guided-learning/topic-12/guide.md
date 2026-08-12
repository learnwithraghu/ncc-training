# Topic 12: Compose Mini Workflow

**Time:** 20 minutes

## Goal
Complete a full Compose workflow from startup to verification (through
both the API and a direct MySQL login) and cleanup.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose up -d --build
until curl -fsS http://localhost:5000/health; do sleep 1; done
curl -X POST http://localhost:5000/items -H 'Content-Type: application/json' -d '{"name":"final-workflow"}'
curl http://localhost:5000/items
docker compose exec db mysql -u appuser -p appdb -e "SELECT * FROM items;"
docker compose logs --tail 20
docker compose down
```

## Guided Steps
1. Build and start the stack.
2. Confirm service health.
3. Insert an item through the API and verify it with `GET /items`.
4. Verify the same row directly in MySQL, without going through the API,
   using `docker compose exec db mysql ... -e "..."` (`-e` runs one SQL
   statement and exits, no interactive prompt needed).
5. Review recent logs, then tear down the stack cleanly.

## Checkpoint
Which Compose concepts (build, health checks, dependencies, env files,
volumes, exec) did you combine in this final workflow?
