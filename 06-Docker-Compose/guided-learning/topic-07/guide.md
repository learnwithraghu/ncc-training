# Topic 7: Volumes and Persistent Data

**Time:** 20 minutes

## Goal
Understand named volumes and verify persistence across restarts.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose up -d
until curl -fsS http://localhost:5000/health; do sleep 1; done
curl -X POST http://localhost:5000/events -H 'Content-Type: application/json' -d '{"title":"volume-check"}'
sleep 2
curl http://localhost:5000/processed
docker compose down
docker compose up -d
until curl -fsS http://localhost:5000/health; do sleep 1; done
curl http://localhost:5000/processed
docker compose down
```

## Guided Steps
1. Start the stack and create an event.
2. Confirm the worker writes processed output.
3. Stop the stack.
4. Start again and verify processed data still exists.
5. Explain where persistence comes from.

## Checkpoint
Which named volume keeps processed data for `web` and `worker`?
