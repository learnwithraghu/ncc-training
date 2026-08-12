# Demo Infra Requirement

## Infra Needed

- Docker Engine running
- Docker Compose plugin (`docker compose`)
- Free host port **5000** for the login UI
- Browser or `curl` to submit a login

## Quick Validation

```bash
docker --version
docker compose version
docker ps
```

## Smoke Test (optional)

From any practical stage folder:

```bash
cd ~/ncc-training/06-Docker-Compose/new-style/03-start-the-stack
docker compose up -d --build
curl http://127.0.0.1:5000
docker compose down
```
