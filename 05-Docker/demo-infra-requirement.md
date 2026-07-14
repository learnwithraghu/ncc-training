# Demo Infra Requirement

## Infra Needed
- Docker Engine running
- Permission to run docker commands
- Internet access to pull base images

## Quick Validation
```bash
docker --version
docker info --format '{{.ServerVersion}}'
docker run --rm hello-world
```
