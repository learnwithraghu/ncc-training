# Topic 10: Service Scaling Patterns

**Time:** 20 minutes

## Goal
Scale a stateless service and observe behavior.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose up -d
docker compose up -d --scale worker=3
docker compose ps
docker compose logs worker
docker compose down
```

## Guided Steps
1. Start the default stack.
2. Scale the worker service to three instances.
3. Inspect running services.
4. Review worker logs to confirm parallel consumers.
5. Explain why workers are easier to scale than stateful databases.

## Checkpoint
What type of service is usually safest to scale first: stateless or stateful?
