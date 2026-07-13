# Topic 9: Logs, Exec, and Troubleshooting

**Time:** 20 minutes

## Goal
Use Compose operations to inspect service behavior and debug issues.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose up -d
docker compose logs web
docker compose logs worker
docker compose logs redis
docker compose exec web sh
docker compose ps
docker compose down
```

## Guided Steps
1. Start the stack.
2. Review logs from each service.
3. Open a shell in `web` and inspect `/app/data`.
4. Use `docker compose ps` to verify states.
5. Explain a troubleshooting sequence for a failing service.

## Checkpoint
Which command do you run first when a Compose service exits unexpectedly?
