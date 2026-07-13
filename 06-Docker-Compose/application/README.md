# Docker Compose Training App

This application is used by the guided learning in the `06-Docker-Compose` module.

## Services

- `web`: Flask API
- `worker`: queue consumer
- `redis`: queue backend

## Endpoints

- `GET /` - app info and hit counter
- `GET /health` - health status (includes Redis connectivity)
- `POST /events` - queue an event
- `GET /events` - pending queue length
- `GET /processed` - processed events from shared volume

## Quick Start

```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose up -d --build
until curl -fsS http://localhost:5000/health; do sleep 1; done
curl -X POST http://localhost:5000/events -H 'Content-Type: application/json' -d '{"title":"demo"}'
curl http://localhost:5000/processed
docker compose down
```

## Notes

- The `web` and `worker` services share `compose_data` volume at `/app/data`.
- Redis data is persisted in `redis_data` volume.
- You can scale workers with `docker compose up -d --scale worker=3`.
