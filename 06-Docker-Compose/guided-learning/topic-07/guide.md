# Topic 7: Volumes and Persistent Data

**Time:** 20 minutes

## Goal
Understand the `db_data` named volume and verify MySQL data survives a
restart.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose up -d
until curl -fsS http://localhost:5000/health; do sleep 1; done
curl -X POST http://localhost:5000/items -H 'Content-Type: application/json' -d '{"name":"volume-check"}'
curl http://localhost:5000/items
docker compose down
docker compose up -d
until curl -fsS http://localhost:5000/health; do sleep 1; done
curl http://localhost:5000/items
docker compose down
```

## Guided Steps
1. Start the stack and insert an item.
2. Confirm `GET /items` shows it.
3. Stop the stack with `docker compose down` (no `-v`, so volumes stay).
4. Start again and verify the item is still there - MySQL replayed it
   from `/var/lib/mysql` on the volume, it didn't re-run `init.sql`.
5. Explain where persistence comes from, and what would happen instead if
   you ran `docker compose down -v`.

## Checkpoint
Why does `init.sql`'s seed data only appear the *first* time you ever
start this stack, not every time?
