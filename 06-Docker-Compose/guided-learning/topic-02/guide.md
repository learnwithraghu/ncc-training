# Topic 2: Compose File Structure Walkthrough

**Time:** 20 minutes

## Goal
Read the Compose file and understand service definitions.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
vi docker-compose.yml
```

## Guided Steps
1. Open `docker-compose.yml` in `vi`.
2. Find `web`, `worker`, and `redis` services.
3. Review `build`, `ports`, `volumes`, and `depends_on`.
4. Explain what the named volumes store.
5. Explain why `env_file` is used.

## Checkpoint
What is one difference between `web` and `worker` in this Compose file?
