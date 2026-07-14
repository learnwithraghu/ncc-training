# Demo Infra Requirement

## Infra Needed
- Docker Engine (to run Jenkins locally)
- Docker Compose plugin
- Free local ports (for Jenkins UI and related services)

## Quick Validation
```bash
docker --version
docker compose version
docker ps
ss -ltn | grep -E ':8080|:8081|:50000' || true
```
