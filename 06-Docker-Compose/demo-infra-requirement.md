# Demo Infra Requirement

## Infra Needed
- Docker Engine running
- Docker Compose plugin (`docker compose`)
- Free local ports for app services (module app uses port 5000 for the
  API and port 3306 for MySQL)
- `curl` available (used in guided topics; optional for the validator)

## Quick Validation
```bash
docker --version
docker compose version
docker ps
```

## Full Validation
Run the module validator before teaching or running the guided topics. It exercises the entire Compose stack end-to-end - including a direct MySQL login - and cleans up after itself.

```bash
/workspaces/ncc-training/06-Docker-Compose/helpers/validate-infra.sh
```
