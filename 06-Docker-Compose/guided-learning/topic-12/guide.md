# Topic 12: Compose Mini Workflow

**Time:** 20 minutes

## Goal
Complete a full Compose workflow from startup to verification and cleanup.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose up -d --build
until curl -fsS http://localhost:5000/health; do sleep 1; done
curl -X POST http://localhost:5000/events -H 'Content-Type: application/json' -d '{"title":"final-workflow"}'
sleep 2
curl http://localhost:5000/processed
docker compose logs --tail 20
docker compose down
```

## Guided Steps
1. Build and start the stack.
2. Confirm service health.
3. Queue an event and verify processing output.
4. Review recent logs.
5. Tear down the stack cleanly.

## Checkpoint
Which Compose concepts did you combine in this final workflow?
