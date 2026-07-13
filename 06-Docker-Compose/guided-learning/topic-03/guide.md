# Topic 3: Validate Compose Config

**Time:** 20 minutes

## Goal
Validate rendered configuration before running services.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose config
```

## Guided Steps
1. Render the full Compose config.
2. Confirm environment values are present from `.env.example`.
3. Confirm health checks appear for `web` and `redis`.
4. Confirm named volumes are defined.
5. Explain why config validation should happen before startup.

## Checkpoint
Why is `docker compose config` useful in CI or local troubleshooting?
