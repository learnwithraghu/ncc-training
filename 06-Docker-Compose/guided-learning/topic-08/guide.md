# Topic 8: Database Workflow with MySQL

**Time:** 20 minutes

## Goal
Follow data from an API call all the way into MySQL, then check it two
ways: through the app, and directly with the `mysql` client inside the
`db` container.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose up -d
until curl -fsS http://localhost:5000/health; do sleep 1; done
curl -X POST http://localhost:5000/items -H 'Content-Type: application/json' -d '{"name":"event-1"}'
curl -X POST http://localhost:5000/items -H 'Content-Type: application/json' -d '{"name":"event-2"}'
curl http://localhost:5000/items
docker compose exec db mysql -u appuser -p appdb
```

## Guided Steps
1. Start the stack and check API health.
2. Insert two items via the API (`POST /items`).
3. Confirm both appear in `GET /items` (this goes through Flask + the
   `appuser` MySQL account).
4. Log into the database container directly - this is the "login to a
   pod and run MySQL commands" step:
   ```bash
   docker compose exec db mysql -u appuser -p appdb
   ```
   Password: `apppassword` (from `docker-compose.yaml`'s `db` service).
5. At the `mysql>` prompt, run:
   ```sql
   SHOW TABLES;
   SELECT * FROM items;
   SELECT COUNT(*) FROM items;
   ```
   and confirm the row count matches what `GET /items` reported. Type
   `exit` to leave the MySQL prompt.

## Checkpoint
The API and your direct `mysql` session both read the same table. What
does that prove about how Compose networking connects `web` to `db`?
