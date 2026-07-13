# Topic 13: Compose with the Sample App

**Time:** 20 minutes

## Goal
Run the sample Flask app with Compose and a persistent data path.

## Commands to Use
```bash
cd /workspaces/ncc-training/05-Docker/application
vi docker-compose.yml
docker compose up -d
docker compose logs -f
docker compose exec app sh
docker compose down
```

## Guided Steps
1. Add the sample app service to Compose.
2. Map port 5000.
3. Mount the data directory.
4. Check the logs.
5. Open a shell inside the service with Compose.

## Checkpoint
Why can Compose be better than typing a long `docker run` command by hand?
