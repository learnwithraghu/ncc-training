# Topic 8: Queue Workflow with Worker

**Time:** 20 minutes

## Goal
Follow the full queue flow from API event creation to worker processing.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose up -d
until curl -fsS http://localhost:5000/health; do sleep 1; done
curl -X POST http://localhost:5000/events -H 'Content-Type: application/json' -d '{"title":"event-1"}'
curl -X POST http://localhost:5000/events -H 'Content-Type: application/json' -d '{"title":"event-2"}'
curl http://localhost:5000/events
sleep 2
curl http://localhost:5000/processed
docker compose down
```

## Guided Steps
1. Start the stack and check API health.
2. Queue multiple events via the API.
3. Check queue length from the API.
4. Confirm worker output in processed logs.
5. Explain how Redis and worker cooperate.

## Checkpoint
Why is separating API and worker useful in real systems?
